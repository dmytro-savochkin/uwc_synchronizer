class AddTypeToSocialNetworks < ActiveRecord::Migration
  def up
    add_column :social_networks, :type, :string
  end

  def down
    remove_column :social_networks, :type
  end
end
