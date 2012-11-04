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

  def avatar_updatable
    false
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
    @client ||= auth
    gists = {}
    threads = []

    @client.gists.list(:per_page => 50).map do |gist|
      gists[gist.id] = {
          :id => gist.id,
          :description => gist.description,
          :public => gist.public,
          :files => {}
      }

      gist.files.each_with_index do |file, index|
        gist_file_name = rename_gist_file_if_name_is_default file.last.filename
        gists[gist.id][:files][index] = {
            :filename => gist_file_name,
            :language => (file.last.language.nil? ? '' : file.last.language)
        }

        threads << Thread.new do
          url = file.last.raw_url.split('/')[0...-1].join('/').to_s
          gists[gist.id][:files][index][:contents] = httpclient.get_content(url).to_s
        end
      end
    end

    threads.map{|t| t.value} # waiting for threads

    gists
  end


  def put_gists(gists)
    @client ||= auth

    ids_to_change_in_cloud_query = {}
    threads = []
    gists.each do |gist|
      data_to_send = {}
      data_to_send[:description] = gist[:description]
      data_to_send[:public] = gist[:public]
      data_to_send[:files] = {}
      gist['files'].each do |key, file|
        filename = rename_gist_file_if_name_is_default file[:filename]
        data_to_send[:files][filename] = {:content => file[:contents].to_s}
      end

      old_gist = @client.gists.get gist[:id] rescue Github::Error::NotFound

      if old_gist
        old_files = old_gist[:files].keys
        new_files = gist['files'].values.map{|f| f[:filename]}
        files_to_delete = old_files - new_files

        files_to_delete.each do |file_to_delete|
          data_to_send[:files][file_to_delete] = 'null'
        end

        threads << Thread.new do
          @client.gists.edit gist[:id], data_to_send
        end
      else
        threads << Thread.new do
          new_gist = @client.gists.create data_to_send
          ids_to_change_in_cloud_query[gist[:id]] = new_gist[:id]
        end
      end
    end

    threads.map{|t| t.value} # waiting for threads

    ids_to_change_in_cloud_query
  end


  def delete_gists(ids)
    @client ||= auth
    threads = []
    ids.each do |id|
      threads << Thread.new do
        @client.gists.delete id rescue Github::Error::NotFound
      end
    end
    threads.map{|t| t.value} # waiting for threads
  end










  private

  def rename_gist_file_if_name_is_default(name)
    name = name.sub(/gistfile/, 'default')
    name
  end

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