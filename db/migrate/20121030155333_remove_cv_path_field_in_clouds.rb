class RemoveCvPathFieldInClouds < ActiveRecord::Migration
  def up
    remove_column :clouds, :cv_file_name
    remove_column :clouds, :picture_file_name
  end

  def down
    add_column :clouds, :cv_file_name, :string
    add_column :clouds, :picture_file_name, :string
  end
end
