class UserFacade

  attr_accessor :user

  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  def age_sex
    "#{@user.sex}, #{@user.age} years old"
  end

  def own?
    @current_user.id == @user.id
  end

  def map_image(trip, width, height)

    trip.map_image_url(width, height)

  end

  def trips
    @user.trips.current
  end

  delegate :full_name, to: :user
  delegate :city, to: :user
  delegate :nationality, to: :user
  delegate :description, to: :user
  delegate :picture_url, to: :user
  delegate :mood, to: :user
  delegate :time, to: :user
  delegate :relationship_status, to: :user

end


