class Trip < ActiveRecord::Base
  belongs_to :user

  BOX_SIZE_IN_METERS = 5000

  scope :near, ->(latitude, longitude, box_size=BOX_SIZE_IN_METERS) { where("earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(latitude, longitude)", latitude, longitude, box_size) }

  scope :from_friends_of, ->(user) { user.nil? ? none : where(:user_id => user.friends.pluck(:id) ) }
  scope :not_from_friends_of, ->(user) { user.nil? ? none : where.not(:user_id => user.friends.pluck(:id) + [user.id] ) }

  def self.find_from_friends_near(user, latitude, longitude)
    Trip.near(latitude, longitude).from_friends_of(user)
  end

  def self.find_not_from_friends_near(user, latitude, longitude)
    Trip.near(latitude, longitude).not_from_friends_of(user)
  end

end
