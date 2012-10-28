Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  end

  #provider :developer unless Rails.env.production?
  provider :twitter, Uwcplus::Application::TWITTER_API[:token], Uwcplus::Application::TWITTER_API[:secret]
  provider :facebook, Uwcplus::Application::FACEBOOK_API[:token], Uwcplus::Application::FACEBOOK_API[:secret]
  provider :vkontakte, Uwcplus::Application::VKONTAKTE_API[:token], Uwcplus::Application::VKONTAKTE_API[:secret]
  provider :linkedin, Uwcplus::Application::LINKEDIN_API[:token], Uwcplus::Application::LINKEDIN_API[:secret]
end


Twitter.configure do |config|
  config.consumer_key = Uwcplus::Application::TWITTER_API[:token]
  config.consumer_secret = Uwcplus::Application::TWITTER_API[:secret]
end

Vkontakte.setup do |config|
  config.app_id = Uwcplus::Application::VKONTAKTE_API[:token]
  config.app_secret = Uwcplus::Application::VKONTAKTE_API[:secret]
  config.format = :json
  config.debug = false
end

