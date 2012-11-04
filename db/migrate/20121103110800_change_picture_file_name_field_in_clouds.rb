class ChangePictureFileNameFieldInClouds < ActiveRecord::Migration
  def up
    add_column :clouds, :picture_data, :binary
  end

  def down
    remove_column :clouds, :picture_data
  end
end
