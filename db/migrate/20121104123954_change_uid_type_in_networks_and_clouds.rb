class ChangeUidTypeInNetworksAndClouds < ActiveRecord::Migration
  def up
    change_column :networks, :uid, :string
  end

  def down
    change_column :networks, :uid, :integer
  end
end
