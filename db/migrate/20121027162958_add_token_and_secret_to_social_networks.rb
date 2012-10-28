class AddTokenAndSecretToSocialNetworks < ActiveRecord::Migration
  def up
    add_column :social_networks, :token, :string
    add_column :social_networks, :secret, :string
  end

  def down
    remove_column :social_networks, :token
    remove_column :social_networks, :secret
  end
end
