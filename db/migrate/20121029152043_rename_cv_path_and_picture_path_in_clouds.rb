class RenameCvPathAndPicturePathInClouds < ActiveRecord::Migration
  def up
    rename_column :clouds, :cv_path, :cv_file_name
    rename_column :clouds, :picture_path, :picture_file_name
  end

  def down
    rename_column :clouds, :cv_file_name, :cv_path
    rename_column :clouds, :picture_file_name, :picture_path
  end
end
