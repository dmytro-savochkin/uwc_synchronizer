class Social::Networks::Github < Social::Network
  def human_name
    'Github'
  end


  def self.email_from_auth_data(auth)
    auth.info.email
  end


  def profile_editable
    true
  end

  def profile_updatable
    true
  end





  def get_info
    client = auth
    data = client.users.get
    {
        provider: self.class_name_without_module,
        name: data[:name],
        description: data[:bio],
        location: data[:location],
        url: data[:blog]
    }
  end


  def put_info(params)
    client = auth
    client.users.update convert_data_to_github_format params
  end








  def get_gists
    httpclient = HTTPClient.new
    client = auth
    gists = {}
    threads = []

    client.gists.list(:per_page => 50).map do |gist|
      gists[gist.id] = {
          :id => gist.id,
          :description => gist.description,
          :public => gist.public,
          :files => {}
      }

      gist.files.each_with_index do |file, index|
        gists[gist.id][:files][index] = {
            :filename => file.last.filename,
            :language => (file.last.language.nil? ? '' : file.last.language)
        }

        threads << Thread.new do
          url = file.last.raw_url.tr(' ', "20")
          gists[gist.id][:files][index][:contents] = httpclient.get_content(url).to_s
        end
      end
    end

    threads.map{|t| t.value} # waiting for threads

    gists
  end


  def put_gists(gists)
    client = auth

    ids_to_change_in_cloud_query = {}
    threads = []
    logger.info 'GITHUB'
    gists.each do |gist|
      data_to_send = {}
      data_to_send[:description] = gist[:description]
      data_to_send[:public] = gist[:public]
      data_to_send[:files] = {}
      gist['files'].each do |key, file|
        filename = file[:filename]
        #filename = 'gistfile1.txt'  # TODO: need to avoid somehow github bug with creating gists
        data_to_send[:files][filename] = {:content => file[:contents].to_s}
      end

      logger.info gist.to_yaml
      logger.info data_to_send.to_yaml

      if gist[:recreate]
        logger.info 'recreate!'
        threads << Thread.new do
          client.gists.delete gist[:id] rescue Github::Error::NotFound
          new_gist = client.gists.create data_to_send
          ids_to_change_in_cloud_query[gist[:id]] = new_gist[:id]
        end
      else
        threads << Thread.new do
          client.gists.edit gist[:id], data_to_send
        end
      end
    end
    logger.info 'GITHUB'

    threads.map{|t| t.value} # waiting for threads

    ids_to_change_in_cloud_query
  end


  def delete_gists(ids)
    client = auth
    threads = []
    ids.each do |id|
      threads << Thread.new do
        client.gists.delete id rescue Github::Error::NotFound
      end
    end
    threads.map{|t| t.value} # waiting for threads
  end










  private

  def auth
    Github.new :oauth_token => token
  end

  def convert_data_to_github_format(data)
    {
        bio: data[:description],
        blog: data[:url],
        name: data[:name],
        location: data[:location]
    }
  end
end