class AddCompositionToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :composition, :string
    execute "UPDATE trips SET composition='A'"
    change_column :trips, :composition, :string, null:false
  end

  def down
    remove_column :trips, :composition
  end
end
