class Social::Networks::Facebook < Social::Network
  def human_name
    'Facebook'
  end

  def self.email_from_auth_data(auth)
    auth.info.email
  end

  def profile_editable
    true
  end
  def profile_updatable
    false
  end
  def avatar_updatable
    true
  end



  def get_avatar
    @client ||= auth
    httpclient = HTTPClient.new
    avatar_url = @client.get_connections('me', 'picture', :type => 'large', :redirect => 'false')['data']['url']
    httpclient.get_content(avatar_url).to_s
  end

  def post_avatar(data)
    @client ||= auth
    file = create_temp_avatar_file(data)
    result = @client.put_picture file
    file.close
    File.delete file.path
    {:redirect => approving_photo_link(result['id'])}
  end





  def get_info
    @client ||= auth
    data = @client.get_object('me')
    {
        provider: self.class_name_without_module,
        name: data['name'],
        description: data['bio'],
        location: data['location']['name'],
        url: data['website']
    }
  end

  def put_info(params)
    false
  end




  private

  def auth
    Koala::Facebook::API.new token
  end

  def approving_photo_link(id)
    'http://www.facebook.com/photo.php?fbid=' + id.to_s + '&makeprofile=1'
  end
end