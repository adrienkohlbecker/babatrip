class HomeController < ApplicationController

  def index

    @home = HomeFacade.new(current_user)
    @home.trips_from_friends = Trip.from_friends_of(current_user)

  end

  def about
  end

end
