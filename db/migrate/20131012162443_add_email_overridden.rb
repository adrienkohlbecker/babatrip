class AddEmailOverridden < ActiveRecord::Migration
  def change
    add_column :users, :is_email_overridden, :boolean, :default => false
  end
end
