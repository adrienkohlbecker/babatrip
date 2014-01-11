class SearchResultsFacade

  attr_accessor :city, :latitude, :longitude, :arriving, :leaving, :trips_from_friends, :locals

  def initialize(city, latitude, longitude, arriving, leaving)
    @city = city
    @latitude = latitude
    @longitude = longitude
    @arriving = arriving
    @leaving = leaving
  end

  def formatted_arriving
    @arriving.strftime('%d %B %Y')
  end

  def formatted_leaving
    @leaving.strftime('%d %B %Y')
  end

  def empty?
    locals.empty? and trips_from_friends.empty?
  end

end
