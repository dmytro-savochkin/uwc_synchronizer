class Social::Networks::Vkontakte < Social::Network
  def human_name
    'Vk.com'
  end

  def self.email_from_auth_data(auth)
    auth.extra.raw_info.domain+'@vk.com'
  end

  def profile_editable
    false
  end
  def profile_updatable
    false
  end
  def avatar_updatable
    false
  end


  def get_avatar
    # TODO: implement
  end


  private

  def auth
    VkontakteApi::Client.new token
  end

end