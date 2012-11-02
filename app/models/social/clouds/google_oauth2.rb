class Social::Clouds::GoogleOauth2 < Social::Cloud
  def human_name
    'Google Drive'
  end
  def gists_folder
    'SocialSync/gists'
  end





  def get_gists
    @client ||= auth
    @root ||= @client.root_collection
    threads = []

    gists = {}

    gist_files = get_gists_folder.files("showdeleted" => false)
    gist_files.each do |file|
      begin
        threads << Thread.new do
          gist_data = JSON.parse(file.download_to_string, :symbolize_names => true)
          gists[gist_data[:id].to_s] = gist_data
        end
      rescue JSON::ParserError
        nil
      end
    end

    threads.map{|t| t.value}
    gists
  end

  def put_gists(gists)
    @client ||= auth
    @root ||= @client.root_collection
    threads = []
    folder = get_gists_folder

    gists.each do |gist|
      file_name = create_gist_name(gist[:id])
      threads << Thread.new do

        # this is stupid solution, yes, but i cant provide another because of
        # error in google drive gem (or google drive itself) which results in
        # impossibility of updating existing files
        file = folder.files(:title => file_name, "title-exact" => true, :showdeleted => false).first

        logger.info file.to_yaml

        unless file.nil?
          folder.remove(file)
        end
        file = @client.upload_from_string(gist.to_json, file_name, :content_type => "text/plain", :convert => false)
        folder.add(file)
        @root.remove(file)

      end
    end
    threads.map{|t| t.value}
  end

  def delete_gists(ids)
    @client ||= auth
    @root ||= @client.root_collection
    threads = []

    ids.each do |id|
      begin
        file_name = create_gist_name(id)
        threads << Thread.new do
          file = get_gists_folder.files("title" => file_name, "title-exact" => true).first
          file.delete true if file
        end
      end
    end


    threads.map{|t| t.value}
  end






  private

  def get_gists_folder
    @client ||= auth
    @root ||= @client.root_collection

    dir = @root
    gists_folder.split('/').each do |folder|
      dir = dir.subcollection_by_title(folder) || dir.create_subcollection(folder)
    end
    dir
  end


  def auth
    client = OAuth2::Client.new(
        Uwcplus::Application::GOOGLE_API[:token], Uwcplus::Application::GOOGLE_API[:secret],
        :site => "https://accounts.google.com",
        :token_url => "/o/oauth2/token",
        :authorize_url => "/o/oauth2/auth"
    )

    if expires_at.to_i <= Time.now.tv_sec
      access_token = OAuth2::AccessToken.from_hash(
          client,
          {:refresh_token => refresh_token, :expires_at => expires_at}
      )
      access_token = access_token.refresh!

      self.token = access_token.token
      self.expires_at = access_token.expires_at
      self.save
    else
      access_token = OAuth2::AccessToken.new(client, token)
    end

    GoogleDrive.login_with_oauth(access_token)
  end
end
