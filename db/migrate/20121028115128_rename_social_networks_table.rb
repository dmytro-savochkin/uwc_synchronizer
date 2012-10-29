class RenameSocialNetworksTable < ActiveRecord::Migration
  def up
    rename_table :social_networks, :socials
  end

  def down
    rename_table :socials, :socials_networks
  end
end
