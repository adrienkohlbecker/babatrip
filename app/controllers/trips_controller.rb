class TripsController < ApplicationController

  before_action :authenticate_user!

  def popin
    trip = Trip.find(params[:id])
    @popin = PopinFacade.new(trip, current_user)
    render layout: false
  end

  def contact #todo
    id = contact_params[:id]
    message = contact_params[:message]
    Rails.logger.info("Send mail to #{id}, #{message}")
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
