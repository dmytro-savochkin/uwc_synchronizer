class CreateSocialNetworks < ActiveRecord::Migration
  def up
    create_table :social_networks do |t|
      t.integer :user_id

      t.string :email
      t.string :name
      t.string :nickname
      t.string :picture

      t.timestamps
    end
  end

  def down
    drop_table :social_networks
  end
end
