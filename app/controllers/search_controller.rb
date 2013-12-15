class SearchController < ApplicationController

  before_action :authenticate_user!

  def index

    city = search_params[:city]
    latitude = search_params[:latitude]
    longitude = search_params[:longitude]
    arriving = search_params[:arriving]
    leaving = search_params[:leaving]

    @search_results = SearchResultsFacade.new(city, latitude, longitude, arriving, leaving)
    @search_results.trips_from_friends = Trip.find_from_friends_near_between(current_user, latitude, longitude, arriving, leaving)
    @search_results.trips_not_from_friends = Trip.find_not_from_friends_near_between(current_user, latitude, longitude, arriving, leaving)

  end

  def create

    city = search_params[:city]
    latitude = search_params[:latitude]
    longitude = search_params[:longitude]
    arriving = search_params[:arriving]
    leaving = search_params[:leaving]

    @search_results = SearchResultsFacade.new(city, latitude, longitude, arriving, leaving)
    @search_results.trips_from_friends = Trip.find_from_friends_near_between(current_user, latitude, longitude, arriving, leaving)
    @search_results.trips_not_from_friends = Trip.find_not_from_friends_near_between(current_user, latitude, longitude, arriving, leaving)

    trip = Trip.new(search_params)
    trip.message = 'Nullam quis risus eget urna mollis ornare vel eu leo. Nulla vitae elit libero, a pharetra augue. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet.' #TODO
    trip.composition = 'A' #TODO
    current_user.trips << trip
    current_user.save!

    flash[:notice] = "Successfully added this trip to your list"
    render :index

  end


  private

    def search_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving)
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y")
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y")
      hash
    end

end
