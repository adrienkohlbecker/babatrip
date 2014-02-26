class HomeController < ApplicationController

  before_action :check_profile_completed, :only => ['index']
  def check_profile_completed
    redirect_to me_edit_path if current_user and not current_user.is_profile_completed
  end

  def index
    @trips_from_friends = current_user ? Trip.current.from_friends_of(current_user) : Trip.none
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
