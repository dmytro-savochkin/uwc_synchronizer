class Social::Dropbox < Social::Cloud
  def human_name
    'Dropbox'
  end
  def gists_folder
    'SocialSync/gists'
  end
  def gists_file
    'data.json'
  end





  def get_gists_data
    client = auth
    gists = {}

    gist_files = client.ls gists_folder
    gist_files.each do |file|
      begin
        gist_data = JSON.parse(file.download, :symbolize_names => true)
        gists[gist_data[:id].to_s] = gist_data
      rescue JSON::ParserError
        nil
      end
    end

    gists
  rescue Dropbox::API::Error::NotFound
    {}
  end

  def put_gists_data(gists)
    client = auth
    begin
      client.mkdir gists_folder
    rescue Dropbox::API::Error::Forbidden
      nil
    end

    gists.each do |gist|
      gist_name = create_gist_name gist[:id]
      client.upload(gists_folder + '/' + gist_name, gist.to_json)
    end
  end

  def delete_gists(ids)
    client = auth

    ids.each do |id|
      begin
        file = client.find gists_folder + '/' + id + '.txt'
        file.destroy
      rescue Dropbox::API::Error::NotFound
        nil
      end
    end
  end





  private

  def create_gist_name(id)
    id.to_s + '.txt'
  end

  def auth
    Dropbox::API::Client.new :token => token, :secret => secret
  end
end
