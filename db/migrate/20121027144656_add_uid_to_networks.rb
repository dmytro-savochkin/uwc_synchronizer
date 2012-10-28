class AddUidToNetworks < ActiveRecord::Migration
  def up
    add_column :social_networks, :uid, :integer
  end

  def down
    remove_column :social_networks, :uid
  end
end
