class SearchResultsFacade

  attr_accessor :city, :latitude, :longitude, :arriving, :leaving

  def initialize(city, latitude, longitude, arriving, leaving)
    @city = city
    @latitude = latitude
    @longitude = longitude
    @arriving = arriving
    @leaving = leaving
  end

  def formatted_arriving
    @arriving.strftime('%B %Y')
  end

  def formatted_leaving
    @leaving.strftime('%B %Y')
  end

end
