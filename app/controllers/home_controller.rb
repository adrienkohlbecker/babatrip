class HomeController < ApplicationController

  def index

    @home = HomeFacade.new(current_user)
    @home.trips_from_friends = Trip.current.from_friends_of(current_user)

  end

  def about
  end

  def legal
  end

end
