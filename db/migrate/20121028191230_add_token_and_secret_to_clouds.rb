class AddTokenAndSecretToClouds < ActiveRecord::Migration
  def up
    add_column :clouds, :token, :string
    add_column :clouds, :secret, :string
  end

  def down
    remove_column :clouds, :token
    remove_column :clouds, :secret
  end
end
