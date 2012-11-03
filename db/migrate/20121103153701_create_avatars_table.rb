class CreateAvatarsTable < ActiveRecord::Migration
  def up
    create_table :avatars do |t|
      t.binary :facebook
      t.binary :twitter
      t.binary :cloud

      t.integer :user_id
    end
  end

  def down
    drop_table :avatars
  end
end
