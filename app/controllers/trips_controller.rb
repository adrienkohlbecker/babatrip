class TripsController < ApplicationController

  before_action :authenticate_user!

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

  def create

    trip = Trip.new(create_params)
    current_user.trips << trip
    current_user.save!

    render nothing: true

  end

  private

    def contact_params
      params.permit(:id, :message)
    end

    def create_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving, :composition, :message)
      hash[:arriving] = Date.strptime(hash[:arriving], "%d/%m/%Y")
      hash[:leaving] = Date.strptime(hash[:leaving], "%d/%m/%Y")
      hash
    end

end
