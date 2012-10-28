# encoding: utf-8
class User < ActiveRecord::Base
  has_many :clouds
  has_many :social_networks


  attr_accessible :email, :password
  attr_accessor :password

  before_save :encrypt_password




  validates :email, :presence => true, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-zа-яА-Я0-9]+\.)+[a-zа-яА-Я]{2,})\Z/i}
  validates_presence_of :password, :on => :create



  def encrypt_password
    if password.present?
      self.password_hash = Digest::MD5.hexdigest(password)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == Digest::MD5.hexdigest(password)
      user
    else
      nil
    end
  end



  def social_networks_in
    self.social_networks.map(&:provider)
  end
  def social_networks_available
    SocialNetwork.kids - social_networks_in
  end


  def clouds_in
    self.clouds.map(&:provider)
  end
  def clouds_available
    Cloud.providers - clouds_in
  end

end