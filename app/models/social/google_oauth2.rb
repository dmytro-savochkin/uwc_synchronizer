class Social::GoogleOauth2 < Social::Cloud
  def human_name
    'Google Drive'
  end
  def cv_folder
    'cv'
  end



  def get_cv_data
    return '' if cv_file_name.nil?
    session = auth
    folder = session.collection_by_title(cv_folder)
    return '' if folder.nil?
    file = folder.files("title" => cv_file_name, "title-exact" => true).first
    file.download_to_string unless file.nil?

  #rescue Exception

  end
  def post_cv(data)
    return false if cv_file_name.nil? or cv_file_name.empty?
    session = auth
    file = session.upload_from_string(data, title = cv_file_name, :content_type => "text/plain", :convert => false)
    root = session.root_collection
    folder = root.create_subcollection(cv_folder)
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
      logger.info access_token.to_yaml
      access_token = access_token.refresh!
      logger.info access_token.to_yaml
    else
      access_token = OAuth2::AccessToken.new(client, token)
    end


    GoogleDrive.login_with_oauth(access_token)
  end
end
