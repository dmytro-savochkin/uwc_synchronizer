class Cloud < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user

  def self.providers
    %w(dropbox)
  end
end
