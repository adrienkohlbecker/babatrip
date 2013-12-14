class PopinFacade

  attr_accessor :trip

  def initialize(trip, current_user)
    @trip = trip
    @current_user = current_user
  end

  def trip_id
    @trip.id
  end

  def message_placeholder
    "Write a message to #{@trip.user.first_name}"
  end

  def user_picture_url
    @current_user.picture_url
  end

end
