class CreateClouds < ActiveRecord::Migration
  def up
    create_table :clouds do |t|
      t.integer :user_id

      t.string :email
      t.string :picture_path
      t.string :cv_path

      t.string :type

      t.timestamps
    end
  end

  def down
    drop_table :clouds
  end
end
