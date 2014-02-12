class TripsController < ApplicationController

  before_action :authenticate_user!, :except => ['image']

  def contact_show
    trip = Trip.find(contact_params[:id])
    @popin = PopinFacade.new(trip, current_user)
    render 'popin', layout: false
  end

  def contact_create
    trip = Trip.find(contact_params[:id])
    message = contact_params[:message]

    UserMailer.message_from_trip(current_user, trip, message).deliver
    render nothing: true
  end

  def edit

    @trip = Trip.find(edit_params[:id])
    render 'edit', layout: false

  end

  def update

    trip = Trip.find(update_params[:id])
    trip.update_attributes!(update_params)
    flash[:notice] = "Trip sucessfully edited"
    render nothing: true

  end

  def delete

    trip = Trip.find(edit_params[:id])
    trip.delete
    flash[:notice] = "Trip sucessfully deleted"
    render nothing: true

  end

  def create

    hash = create_params
    hash.delete(:share)

    trip = Trip.new(hash)
    current_user.trips << trip
    current_user.save!

    if create_params[:share] == "1"
      trip.share_on_facebook
    end

    render nothing: true

  end

  def image

    trip = Trip.find(image_params[:id])

    params = {
      key: ENV['GOOGLE_API_KEY'],
      center: "#{trip.latitude},#{trip.longitude}",
      sensor: false,
      zoom: 11,
      size: "#{image_params[:width].to_i}x#{image_params[:height].to_i}",
      language: I18n.locale,
      region: 'en' #TODO
    }

    image = "http://maps.googleapis.com/maps/api/staticmap?#{params.to_query}"

    response.headers["Expires"] = 1.year.from_now.httpdate
    response.headers["Cache-Control"] = 'public'

    Tempfile.open('map_image', Rails.root.join('tmp') ) do |f|
      f.binmode
      f << open(image).read
      send_file f, :type=>"image/png", :disposition => "inline", :x_sendfile=>true
    end

  end

  private

    def image_params
      params.permit(:id, :height, :width)
    end

    def edit_params
      params.permit(:id)
    end

    def contact_params
      params.permit(:id, :message)
    end

    def create_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving, :composition, :message, :share)
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y")
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y")
      hash
    end

    def update_params
      hash = params.permit(:id, :city, :latitude, :longitude, :arriving, :leaving, :composition, :message)
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y")
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y")
      hash
    end

end
