class HomeController < ApplicationController

  before_action :check_profile_completed, :only => ['index']

  def check_profile_completed

    if current_user and not current_user.is_profile_completed
      redirect_to me_edit_path
    end

  end

  def index

    @home = HomeFacade.new(current_user)
    @home.trips_from_friends = Trip.current.from_friends_of(current_user)

  end

  def about
  end

  def legal
  end

  def privacy
  end

  def landing_page
    render 'landing_page', layout: 'empty'
  end

end
