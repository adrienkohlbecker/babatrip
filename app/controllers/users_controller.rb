class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_user
  before_action :check_profile_completed

  def check_profile_completed

    if current_user and not current_user.is_profile_completed
      redirect_to me_edit_path
    end

  end

  def show
    @user_profile = UserFacade.new(@user, current_user)
  end

  def contact_show
    render 'popin', layout: false
  end

  def contact_create
    message = contact_params[:message]

    UserMailer.message_from_profile(current_user, @user, message).deliver
    render nothing: true
  end

  private

    def find_user

      if user_params[:id_or_username].to_i > 0
        @user = User.find user_params[:id_or_username]
      else
        @user = User.where(:username => user_params[:id_or_username]).first
      end

    end

    def user_params
      params.permit(:id_or_username)
    end

    def contact_params
      params.permit(:id_or_username, :message)
    end

end
