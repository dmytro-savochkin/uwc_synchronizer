class LinkedinNetwork < SocialNetwork
  def self.email_from_auth_data(auth)
    auth.info.email
  end



  def get_info
    client = LinkedIn::Client.new(Uwcplus::Application::LINKEDIN_API[:token], Uwcplus::Application::LINKEDIN_API[:secret])
    client.authorize_from_access(token, secret)
    client.profile(:fields => %w(formatted-name member-url-resources picture-url location summary email-address))
  end
end