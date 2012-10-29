class RenameSocialsTable < ActiveRecord::Migration
  def up
    rename_table :socials, :networks
  end

  def down
    rename_table :networks, :socials
  end
end
