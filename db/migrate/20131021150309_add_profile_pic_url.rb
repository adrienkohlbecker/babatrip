class AddProfilePicUrl < ActiveRecord::Migration
  def change
    add_column :users, :picture_url, :string, :null => true
  end
end
