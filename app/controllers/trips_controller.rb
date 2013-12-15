class TripsController < ApplicationController

  before_action :authenticate_user!

  def contact_show
    trip = Trip.find(params[:id])
    @popin = PopinFacade.new(trip, current_user)
    render 'popin', layout: false
  end

  def contact_create
    trip = Trip.find(contact_params[:id])
    message = contact_params[:message]

    UserMailer.message_from_trip(current_user, trip, message).deliver
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
