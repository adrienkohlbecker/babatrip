class MeController < ApplicationController

  before_action :authenticate_user!

  def show
    redirect_to user_show_path(current_user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.first_name = update_params[:user][:first_name]
    @user.last_name = update_params[:user][:last_name]
    @user.email = update_params[:user][:email]

    if not @user.is_profile_completed
      @user.accepts = update_params[:user][:accepts]

      if update_params[:share] == "1"

        url = "http://#{ENV['DOMAIN']}/"
        graph = Koala::Facebook::API.new(@user.facebook_token, ENV['FACEBOOK_APP_SECRET'])
        begin
          graph.put_wall_post("I'm using Travel-Meet to share my trips and find out where my friends are going. Join me!", {:link => url})
        rescue => e
          # We don't have permission
        end

      end
    end

    if @user.email_changed?
      @user.is_email_overridden = true
      # resend verification ?
    end

    day   = update_params[:user]["birth_date(3i)"].to_i
    month = update_params[:user]["birth_date(2i)"].to_i
    year  = update_params[:user]["birth_date(1i)"].to_i

    date = Date.civil(year, month, day) rescue nil

    if date
      if date < 18.years.ago
        @user.birth_date = date
      else
        @user.errors.add(:birth_date, "is too recent")
      end
    elsif year == 0 and month == 0 and day == 0
      @user.birth_date = nil
    else
      @user.errors.add(:birth_date, "is invalid")
    end

    @user.sex = update_params[:user][:sex]
    @user.relationship_status = update_params[:user][:relationship_status]
    @user.mood = update_params[:user][:mood]
    @user.time = update_params[:user][:time]

    @user.description = update_params[:user][:description]

    @user.nationality = update_params[:user][:nationality]
    @user.city = update_params[:user][:city]
    @user.latitude = update_params[:user][:latitude]
    @user.longitude = update_params[:user][:longitude]

    is_signup = !@user.is_profile_completed

    @user.is_profile_completed = true

    if @user.errors.empty? && user.save
      redir = is_signup ? root_path : my_profile_path
      redirect_to session.delete("user_return_to") || redir
    else
      flash[:notice] = @user.errors.full_messages.join(".\n")
      render 'edit'
    end
  end

  private

    def update_params
      params.permit(:share, :user => [:first_name, :last_name, :email, :sex, :relationship_status, :nationality, :city, :latitude, :longitude, :mood, :time, :description, :accepts, "birth_date(1i)", "birth_date(2i)", "birth_date(3i)"])
    end

end
