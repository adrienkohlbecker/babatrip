class AddMessageToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :message, :string, :null => false
  end
end
