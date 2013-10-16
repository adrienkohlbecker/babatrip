class AddProfileCompleted < ActiveRecord::Migration
  def change
    add_column :users, :is_profile_completed, :boolean, :default => false, :null => false
  end
end
