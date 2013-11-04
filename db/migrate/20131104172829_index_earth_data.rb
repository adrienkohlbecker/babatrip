class IndexEarthData < ActiveRecord::Migration
  def up
    execute "CREATE INDEX index_trips_on_earth_data ON trips USING gist (ll_to_earth(latitude, longitude));"
  end
  def down
    execute "DROP INDEX index_trips_on_earth_data;"
  end
end
