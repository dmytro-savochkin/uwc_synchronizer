class Social::Networks::Twitter < Social::Network
  def human_name
    'Twitter'
  end


  def self.email_from_auth_data(auth)
    auth.info.nickname+'@twitter.com'
  end

  def profile_editable
    true
  end
  def profile_updatable
    true
  end
  def avatar_updatable
    true
  end



  def get_avatar
    @client ||= auth
    httpclient = HTTPClient.new
    avatar_url = @client.user[:attrs][:profile_image_url].to_s.gsub(/_normal/, '')
    httpclient.get_content(avatar_url).to_s
  end

  def post_avatar(data)
    @client ||= auth
    file = create_temp_avatar_file(data)


    logger.info '11111111111111111111111111111111'
    logger.info '11111111111111111111111111111111'
    logger.info '11111111111111111111111111111111'
    logger.info '11111111111111111111111111111111'
    logger.info '11111111111111111111111111111111'
    logger.info '11111111111111111111111111111111'

    @client.update_profile_image file
    file.close
    File.delete file.path
    {}
  end






  def get_info
    @client ||= auth
    data = @client.user
    {
        provider: self.class_name_without_module,
        name: data.attrs[:name],
        description: data.attrs[:description],
        location: data.attrs[:location],
        url: data.attrs[:url]
    }
  end


  def put_info(params)
    @client ||= auth
    @client.update_profile(params.reject{|key, v| key.to_s == 'provider'})
  end



  private

  def auth
    Twitter::Client.new(
        :oauth_token => token,
        :oauth_token_secret => secret
    )
  end
end