class MeController < ApplicationController

  def show
    @profile = ProfileFacade.new(current_user)
  end

  def edit
    @profile = ProfileFacade.new(current_user)
  end

  def update
    user = current_user
    user.first_name = me_params[:user][:first_name]
    user.last_name = me_params[:user][:last_name]
    user.email = me_params[:user][:email]

    if user.email_changed?
      user.is_email_overridden = true
      # resend verification ?
    end

    year  = me_params[:user]["birth_date(1i)"].to_i
    month = me_params[:user]["birth_date(2i)"].to_i
    day   = me_params[:user]["birth_date(3i)"].to_i
    date = Date.civil(year, month, day) rescue nil

    if date
      user.birth_date = date
    elsif year == 0 and month == 0 and day == 0
      user.birth_date = nil
    else
      user.errors.add(:birth_date, "is invalid")
    end

    user.sex = me_params[:user][:sex]
    user.relationship_status = me_params[:user][:relationship_status]
    user.mood = me_params[:user][:mood].reject(&:empty?)
    user.time = me_params[:user][:time].reject(&:empty?)
    user.nationality = me_params[:user][:nationality]

    user.is_profile_completed = true

    if !user.errors.any? && user.save
      redirect_to root_path
    else
      @profile = ProfileFacade.new(user)
      render 'edit'
    end
  end

  private

    def me_params
      puts ap params
      params.permit(:user => [:first_name, :last_name, :email, :sex, :relationship_status, :nationality, {:mood => []}, {:time => []}, "birth_date(1i)", "birth_date(2i)", "birth_date(3i)"])
    end

end
