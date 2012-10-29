class CreatePrimaryForFieldInClouds < ActiveRecord::Migration
  def up
    add_column :clouds, :primary_for, :integer
  end

  def down
    remove_column :clouds, :primary_for
  end
end
