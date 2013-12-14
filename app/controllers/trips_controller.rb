class TripsController < ApplicationController

  before_action :authenticate_user!

  def popin
    trip = Trip.find(params[:id])
    @popin = PopinFacade.new(trip, current_user)
    render layout: false
  end

  def contact
    trip = Trip.find(contact_params[:id])
    message = contact_params[:message]

    UserMaler.message_from_trip(current_user, trip, message).deliver
    render nothing: true
  end

  private

    def contact_params
      params.permit(:id, :message)
    end

    def trip_params
      params.permit(:id)
    end

end
