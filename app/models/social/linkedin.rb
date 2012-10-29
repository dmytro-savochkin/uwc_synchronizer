class Social::Linkedin < Social::Network
  def human_name
    'LinkedIn'
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




  def auth
    client = LinkedIn::Client.new(
        Uwcplus::Application::LINKEDIN_API[:token],
        Uwcplus::Application::LINKEDIN_API[:secret]
    )
    client.authorize_from_access(token, secret)
    client
  end


  def get_info
    client = auth
    data = client.profile(:fields => %w(formatted-name location summary member-url-resources))
    {
        provider: self.class_name_without_module,
        name: data['formatted_name'],
        description: data['summary'],
        location: data['location']['name'],
        url: data['member-url-resources'].to_s
    }
  end

  def put_info(params)
    false
  end





  def get_cv_data
    client = auth
    cv_data = client.profile(
        :fields => %w(positions specialties summary industry location headline formatted-name)
    )
    cv_data.to_json
  end
end