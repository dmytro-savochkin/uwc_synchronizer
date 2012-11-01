class Social::Github < Social::Network
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
    data = client.get
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






  def get_gists_data
    httpclient = HTTPClient.new
    client = auth
    gists = {}
    client.gists.list.map do |gist|
      gists[gist.id] = {
          :id => gist.id,
          :description => gist.description,
          :public => gist.public,
          :files => {}
      }

      gist.files.each_with_index do |file, index|
        gists[gist.id][:files][index] = {
            :filename => file.last.filename,
            :language => (file.last.language.nil? ? '' : file.last.language),
            :contents => httpclient.get_content(file.last.raw_url).to_s
        }
      end
    end
    gists
  end


  def put_gists_data(gists)
    client = auth
    logger.info gists.to_yaml

    ids_to_change_in_cloud_query = {}

    gists.each do |gist|
      data_to_send = {}
      data_to_send[:description] = gist[:description]
      data_to_send[:public] = gist[:public]
      data_to_send[:files] = {}
      gist['files'].each do |key, file|
        logger.info key.to_yaml
        logger.info file.to_yaml
        data_to_send[:files][file[:filename]] = {:content => file[:contents].to_s}
      end

      logger.info '-------------'
      logger.info data_to_send.to_yaml
      logger.info '-------------'

      if gist[:recreate]
        logger.info 'recreate!'
        client.gists.delete gist[:id]
        new_gist = client.gists.create data_to_send
        ids_to_change_in_cloud_query[gist[:id]] = new_gist[:id]
      else
        logger.info 'not recreate?'
        client.gists.edit gist[:id], data_to_send
      end
    end

    ids_to_change_in_cloud_query
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