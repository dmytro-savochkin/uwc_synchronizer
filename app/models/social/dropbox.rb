class Social::Dropbox < Social::Cloud
  def human_name
    'Dropbox'
  end
  def gists_folder
    'SocialSync/gists'
  end






  def get_gists_data
    client = auth
    begin
      gists = {}

      gist_files = client.ls gists_folder
      gist_files.each do |file|
        begin
          gist_data = JSON.parse file.download
          gists[gist_data[:id]] = gist_data
        rescue JSON::ParserError
          nil
        end
      end

      gists
    rescue Dropbox::API::Error::NotFound
      {}
    end
  end

  def post_gists_data(data)
    #return false if cv_file_name.nil? or cv_file_name.empty?
    #client = auth


    ##begin
    ##  client.find(cv_folder)
    ##rescue Dropbox::API::Error::NotFound => e
    ##  client.mkdir cv_folder
    ##end

    #client.upload(gists_folder + '/' + cv_file_name, data)
  end




  private

  def auth
    Dropbox::API::Client.new :token => token, :secret => secret
  end
end
