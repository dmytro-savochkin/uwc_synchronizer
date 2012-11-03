class ChangePictureFileNameFieldInClouds < ActiveRecord::Migration
  def up
    rename_column :clouds, :picture_file_name, :picture_data
    change_column :clouds, :picture_data, :binary
  end

  def down
    rename_column :clouds, :picture_data, :picture_file_name
    change_column :clouds, :picture_file_name, :string
  end
end
