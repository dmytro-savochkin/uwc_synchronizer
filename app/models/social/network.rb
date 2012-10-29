class Social::Network < ActiveRecord::Base
  self.inheritance_column = :provider

  belongs_to :user


  attr_accessible :uid, :name, :nickname, :email, :picture, :provider, :user_id,
                  :token, :secret



  def self.kids
    %w(Social::Facebook Social::Twitter Social::Linkedin Social::Github)
  end










  def self.create_oauth(auth, current_user)
    provider = self.to_s
    email = self.email_from_auth_data(auth)
    network = self.where(:provider => provider, :email => email).first
    image = auth.info.image || ""
    if network
      false
    else
      self.create(
          name:auth.info.name,
          nickname:auth.info.nickname,
          provider:provider,
          uid:auth.uid,
          picture:image,
          email: email,
          user_id: current_user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret
      )
    end
  end





  def human_name
    ''
  end

  def class_name_without_module
    self.class.name.to_s.split('::').last || ''
  end
end
