class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :real
    add_column :users, :longitude, :real
  end
end
