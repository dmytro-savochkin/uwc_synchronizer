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



  def get_info
    client = Twitter::Client.new(
        :oauth_token => token,
        :oauth_token_secret => secret
    )
    data = client.user
    {
        provider: self.class_name_without_module,
        name: data.attrs[:name],
        description: data.attrs[:description],
        location: data.attrs[:location],
        url: data.attrs[:url]
    }
  end


  def put_info(params)
    client = Twitter::Client.new(
        :oauth_token => token,
        :oauth_token_secret => secret
    )
    client.update_profile(params.reject{|key, v| key.to_s == 'provider'})
  end
end