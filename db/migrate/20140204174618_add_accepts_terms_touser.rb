class AddAcceptsTermsTouser < ActiveRecord::Migration
  def up
    add_column :users, :accepts, :boolean
    execute 'UPDATE users SET accepts=TRUE'
  end

  def down
    remove_column :users, :accepts
  end
end
