class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    if user_params[:id_or_username].to_i > 0
      user = User.find user_params[:id_or_username]
    else
      user = User.where(:username => user_params[:id_or_username]).first
    end

    @user_profile = UserFacade.new(user)
  end

  private

    def user_params
      params.permit(:id_or_username)
    end

end
