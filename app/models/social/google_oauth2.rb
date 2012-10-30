class Social::GoogleOauth2 < Social::Cloud
  def human_name
    'Google Drive'
  end
  def gists_folder
    'gists'
  end





  def get_gists_data
    return {} if cv_file_name.nil?
    session = auth
    folder = session.collection_by_title(gists_folder)
    return {} if folder.nil?
    folder_files = folder.files("title" => cv_file_name, "title-exact" => true, "showdeleted" => false)
    file = folder_files.first

    if file
      {data: file.download_to_string, url: file.human_url}
    else
      {}
    end
  end

  def post_gists(data)
    return false if cv_file_name.nil? or cv_file_name.empty?
    session = auth
    file = session.upload_from_string(data, title = cv_file_name, :content_type => "text/plain", :convert => false)
    root = session.root_collection
    folder = root.create_subcollection(gists_folder)
    folder.add(file)
    root.remove(file)
  end






  private

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
