class AddUsername < ActiveRecord::Migration
  def up
    add_column :users, :username, :string
    execute "UPDATE users SET username=uid"
    change_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
  end
end
