class TwitterNetwork < SocialNetwork
  def self.email_from_auth_data(auth)
    auth.info.nickname+'@twitter.com'
  end



  def get_info
    client = Twitter::Client.new(
        :oauth_token => token,
        :oauth_token_secret => secret
    )
    client.user
  end


  def post_info
    #client = Twitter::Client.new(
    #    :oauth_token => token,
    #    :oauth_token_secret => secret
    #)
    #client.update_profile(:name => "Test Test")
  end
end