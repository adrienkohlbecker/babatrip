class HomeFacade

  attr_accessor :trips_from_friends, :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def logged_in?
    !@current_user.nil?
  end

end
