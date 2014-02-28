class UseArraysForFriends < ActiveRecord::Migration
  def up
    add_column :users, :facebook_friends, :string, array: true
    execute "UPDATE users SET facebook_friends = ARRAY(SELECT this_id FROM connections WHERE other_id = users.uid UNION SELECT other_id FROM connections WHERE this_id = users.uid)"
    drop_table :connections
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
