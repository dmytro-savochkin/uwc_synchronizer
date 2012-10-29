class RemoveCloudsAndSocialnetworksFieldsInUsers < ActiveRecord::Migration
  def up
    remove_column :users, :clouds
    remove_column :users, :social_networks
  end

  def down
    add_column :users, :clouds, :string
    add_column :users, :social_networks, :string
  end
end
