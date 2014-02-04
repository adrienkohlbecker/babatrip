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

    trip = Trip.new(create_params)
    current_user.trips << trip
    current_user.save!

    render nothing: true

  end

  private

    def edit_params
      params.permit(:id)
    end

    def contact_params
      params.permit(:id, :message)
    end

    def create_params
      hash = params.permit(:city, :latitude, :longitude, :arriving, :leaving, :composition, :message)
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
