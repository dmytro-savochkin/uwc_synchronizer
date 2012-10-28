class RenameTypeInNetworksAndClouds < ActiveRecord::Migration
  def up
    rename_column :social_networks, :type, :provider
    rename_column :clouds, :type, :provider
  end

  def down
    rename_column :social_networks, :provider, :type
    rename_column :clouds, :provider, :type
  end
end
