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
    #@client ||= auth
    #logger.info @client.photos.getAlbumsCount
    #album_id = @client.photos.get_albums.first

    #server = @client.photos.get_profile_upload_server['upload_url']
    #response = VkontakteApi.upload(
    #    :url => server,
    #    :photo => ['./vendor/assets/images/cat2.jpg', 'image/jpeg']
    #)
    #result = @client.photos.save_profile_photo response



    #result
  end


  private

  def auth
    VkontakteApi::Client.new token
    #Vkontakte::App::User.new uid, :access_token => token
  end

end