class Social::Github < Social::Network
  def human_name
    'Github'
  end


  def self.email_from_auth_data(auth)
    auth.info.email
  end


  def profile_editable
    true
  end

  def profile_updatable
    true
  end



  def get_info
    user = Github::Users.new(:oauth_token => token)
    data = user.get
    {
        provider: self.class_name_without_module,
        name: data[:name],
        description: data[:bio],
        location: data[:location],
        url: data[:blog]
    }
  end


  def put_info(params)
    github = Github.new :oauth_token => token
    github.users.update convert_data_to_github_format params
  end





  private

  def convert_data_to_github_format(data)
    {
        bio: data[:description],
        blog: data[:url],
        name: data[:name],
        location: data[:location]
    }
  end
end