class VkontakteNetwork < SocialNetwork
  def self.email_from_auth_data(auth)
    auth.extra.raw_info.domain+'@vk.com'
  end

  def get_info
    user = Vkontakte::App::User.new(uid, :access_token => token)
    user.fetch
  end
end