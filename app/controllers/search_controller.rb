class SearchController < ApplicationController

  before_action :authenticate_user!

  def index

    city = search_params[:city]
    latitude = search_params[:latitude]
    longitude = search_params[:longitude]
    arriving = search_params[:arriving]
    leaving = search_params[:leaving]

    friends = current_user.friends
    friends_of_friends = friends.collect(&:friends).flatten

    friends_ids = friends.collect(&:id)
    friends_of_friends_ids = friends_of_friends.collect(&:id).uniq - [current_user.id]
    ids = (friends_ids + friends_of_friends_ids).uniq

    trips = Trip.find_near_between(current_user, latitude, longitude, arriving, leaving)

    @search_results = SearchResultsFacade.new(city, latitude, longitude, arriving, leaving)
    @search_results.trips_from_friends = trips.select{|t| ids.include?(t.user_id) }
    @search_results.trips_from_others = trips.select{|t| !ids.include?(t.user_id) }
    @search_results.locals = User.find_near_location(latitude, longitude)

  end

  private

    def search_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving)
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y")
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y")
      hash
    end

end
