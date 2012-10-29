class Social::Cloud < ActiveRecord::Base
  self.inheritance_column = :provider

  belongs_to :user, :primary_key => :user_id
  belongs_to :user, :primary_key => :primary_for

  attr_accessible :provider, :email, :user_id, :token, :secret, :refresh_token, :expires_at

  def self.kids
    %w(Social::Dropbox Social::GoogleOauth2)
  end

  def human_name
    ''
  end


  def self.create_oauth(auth, current_user)
    provider = self.to_s
    cloud = self.where(:provider => provider, :email => auth.info.email).first
    if cloud
      false
    else
      self.create(
          provider:provider,
          email: auth.info.email,
          user_id: current_user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret,
          refresh_token: auth.credentials.refresh_token,
          expires_at:auth.credentials.expires_at
      )
    end
  end
end
