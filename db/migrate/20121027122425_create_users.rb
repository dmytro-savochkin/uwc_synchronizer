class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :clouds
      t.string :social_networks

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
