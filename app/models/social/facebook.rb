class Social::Facebook < Social::Network
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



  def get_info
    graph = Koala::Facebook::API.new(token)
    data = graph.get_object("me")
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
end