class SearchController < ApplicationController

  before_action :authenticate_user!

  def index

    city = search_params[:city]
    latitude = search_params[:latitude]
    longitude = search_params[:longitude]
    arriving = search_params[:arriving]
    leaving = search_params[:leaving]

    if [city, latitude, longitude, arriving, leaving].compact.length != 5
      flash[:alert] = "You must complete all the search fields"
      redirect_to "/"
    end

    friends = current_user.friends
    friends_of_friends = friends.collect(&:friends).flatten

    friends_ids = friends.collect(&:id)
    friends_of_friends_ids = friends_of_friends.collect(&:id).uniq - friends_ids - [current_user.id]

    trips = Trip.find_near_between(current_user, latitude, longitude, arriving, leaving)

    @search_results = SearchResultsFacade.new(city, latitude, longitude, arriving, leaving)
    @search_results.trips_from_friends = trips.select{|t| friends_ids.include?(t.user_id) }
    @search_results.trips_from_friends_of_friends = trips.select{|t| friends_of_friends_ids.include?(t.user_id) }
    @search_results.locals = User.find_near_location(latitude, longitude).select{|u| u.id != current_user.id }

  end

  private

    def search_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving)
      hash[:city] = (hash[:city] && hash[:city] != '') ? hash[:city] : nil
      hash[:latitude] = (hash[:latitude] && hash[:latitude] != '') ? hash[:latitude] : nil
      hash[:longitude] = (hash[:longitude] && hash[:longitude] != '') ? hash[:longitude] : nil
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y") rescue nil
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y") rescue nil
      hash
    end

end
