class SocialNetwork < ActiveRecord::Base
  self.inheritance_column = :provider

  belongs_to :user


  attr_accessible :uid, :name, :nickname, :email, :picture, :provider, :user_id,
                  :token, :secret


  #def self.email_from_auth_data(auth)
    #email = auth.info.email if provider == "google_oauth2"
  #end



  def self.kids
    %w(FacebookNetwork VkontakteNetwork TwitterNetwork LinkedinNetwork)
  end


  def self.factory(provider)
    class_name_from_provider(provider).constantize
  end

  def self.class_name_from_provider(provider)
    provider.capitalize + 'Network'
  end





  def self.create_oauth(provider, auth, current_user)
    provider = self.class_name_from_provider(provider)
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
end
