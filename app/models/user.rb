# encoding: utf-8
class User < ActiveRecord::Base
  has_many :clouds, :class_name => Social::Cloud, :foreign_key => :user_id
  has_one :preferred_cloud, :class_name => Social::Cloud, :foreign_key => :primary_for

  has_many :social_networks, :class_name => Social::Network


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







  def social_networks_available
    Social::Network.kids - social_networks_as_strings
  end

  def clouds_available
    Social::Cloud.kids - clouds_as_strings
  end

  def all_updatable_networks_without(network_class_name)
    network_class = Social::Network.factory network_class_name
    self.
        social_networks.
        select(&:profile_updatable).
        reject{|n| n.class.name.to_s == network_class.to_s}
  end










  private

  def social_networks_as_strings
    self.social_networks.map(&:provider)
  end

  def clouds_as_strings
    self.clouds.map(&:provider)
  end
end