class Trip < ActiveRecord::Base
  belongs_to :user

  BOX_SIZE_IN_METERS = 5000

  COMPOSITION_COLLECTION = ['Alone', 'Couple', 'With friends']

  scope :from_friends_of, ->(user) { user.nil? ? none : where(:user_id => user.friends.pluck(:id) ) }
  scope :current, ->() { order('arriving ASC', 'leaving ASC').where('leaving > ?', Date.today) }

  def self.find_near_between(current_user, latitude, longitude, arriving, leaving)

    trips_to_consider = ActiveRecord::Base.connection.execute %Q{

      SELECT trips.id, users.mood, users.time,
        earth_distance(ll_to_earth(#{ActiveRecord::Base.connection.quote(latitude)}, #{ActiveRecord::Base.connection.quote(longitude)}), ll_to_earth(trips.latitude, trips.longitude)) AS distance
      FROM trips
      INNER JOIN users ON users.id = trips.user_id
      WHERE
        (earth_box(ll_to_earth(#{ActiveRecord::Base.connection.quote(latitude)}, #{ActiveRecord::Base.connection.quote(longitude)}), #{BOX_SIZE_IN_METERS}) @> ll_to_earth(trips.latitude, trips.longitude))
        AND ((trips.arriving, trips.leaving) OVERLAPS (#{ActiveRecord::Base.connection.quote(arriving)}, #{ActiveRecord::Base.connection.quote(leaving)}))
        AND leaving >= #{ActiveRecord::Base.connection.quote(Date.today)}
        AND trips.user_id != #{ActiveRecord::Base.connection.quote(current_user.id)}
    }

    ids_to_properties = {}
    trips_to_consider.each {|r|

      match = 0
      if r['mood'] == current_user.mood
        match += 1
      end
      if r['time'] == current_user.time or r['time'] == 'All day' or current_user.time = 'All day'
        match += 1
      end

      ids_to_properties[r['id'].to_i] = {
        :distance => r['distance'],
        :mood => r['mood'],
        :time => r['time'],
        :match => match
      }

    }

    trips = Trip.where(:id => ids_to_properties.keys).to_a
    trips.sort_by! {|trip| [-ids_to_properties[trip.id][:match], ids_to_properties[trip.id][:distance], trip.arriving, trip.leaving] }

    return trips

  end

end




