class RemovePictureDataFromClouds < ActiveRecord::Migration
  def up
    remove_column :clouds, :picture_data
  end

  def down
    add_column :clouds, :picture_data, :binary
  end
end
