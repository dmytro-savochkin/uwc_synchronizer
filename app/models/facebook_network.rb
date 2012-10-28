class FacebookNetwork < SocialNetwork
  def self.email_from_auth_data(auth)
    auth.info.email
  end

  def get_info
    graph = Koala::Facebook::API.new(token)
    graph.get_object("me")
  end
end