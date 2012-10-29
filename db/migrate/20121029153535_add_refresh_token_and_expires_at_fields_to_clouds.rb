class AddRefreshTokenAndExpiresAtFieldsToClouds < ActiveRecord::Migration
  def up
    add_column :clouds, :expires_at, :string
    add_column :clouds, :refresh_token, :string
  end

  def down
    remove_column :clouds, :expires_at
    remove_column :clouds, :refresh_token
  end
end
