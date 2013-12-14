class HomeController < ApplicationController

  def index

    @home = HomeFacade.new
    @home.trips_from_friends = Trip.from_friends_of(current_user)

  end

end
