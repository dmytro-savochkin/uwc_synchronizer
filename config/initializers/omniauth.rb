Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  end

  #provider :developer unless Rails.env.production?
  provider :twitter, Uwcplus::Application::TWITTER_API[:token], Uwcplus::Application::TWITTER_API[:secret]
  provider :facebook, Uwcplus::Application::FACEBOOK_API[:token], Uwcplus::Application::FACEBOOK_API[:secret], :scope => 'user_website,email,user_about_me'
  provider :linkedin, Uwcplus::Application::LINKEDIN_API[:token], Uwcplus::Application::LINKEDIN_API[:secret]
  provider :github, Uwcplus::Application::GITHUB_API[:token], Uwcplus::Application::GITHUB_API[:secret], :scope => 'user,gist'

  provider :dropbox, Uwcplus::Application::DROPBOX_API[:token], Uwcplus::Application::DROPBOX_API[:secret]
  provider :google_oauth2, Uwcplus::Application::GOOGLE_API[:token], Uwcplus::Application::GOOGLE_API[:secret],
           :scope => "https://docs.google.com/feeds/,https://docs.googleusercontent.com/,https://spreadsheets.google.com/feeds/,userinfo.profile,userinfo.email",
           :access_type => 'offline',
           :approval_prompt => 'force'
end


OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}


Twitter.configure do |config|
  config.consumer_key = Uwcplus::Application::TWITTER_API[:token]
  config.consumer_secret = Uwcplus::Application::TWITTER_API[:secret]
end


Dropbox::API::Config.app_key    = Uwcplus::Application::DROPBOX_API[:token]
Dropbox::API::Config.app_secret = Uwcplus::Application::DROPBOX_API[:secret]
Dropbox::API::Config.mode       = "dropbox"


