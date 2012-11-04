class Social::Network < ActiveRecord::Base
  self.inheritance_column = :provider

  belongs_to :user


  attr_accessible :uid, :name, :nickname, :email, :picture, :provider, :user_id,
                  :token, :secret


  def profile_editable
    false
  end
  def profile_updatable
    false
  end
  def avatar_updatable
    false
  end



  def self.kids
    %w(Social::Networks::Facebook Social::Networks::Twitter Social::Networks::Linkedin
    Social::Networks::Github Social::Networks::Vkontakte)
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



  protected

  def create_temp_avatar_file(data)
    file_name = Avatar.path_to_avatars + rand(1000000).to_s + '.jpg'
    File.open(file_name, 'wb') do |f|
      f.write data
    end
    File.open(file_name, 'rb')
  end
end
