class RemoveProfilePicUrl < ActiveRecord::Migration
  def change
    remove_column :users, :picture_url, :string, :null => true
  end
end
