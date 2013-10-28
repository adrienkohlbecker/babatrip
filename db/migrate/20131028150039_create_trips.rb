class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :city, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.date :arriving, null: false
      t.date :leaving, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
