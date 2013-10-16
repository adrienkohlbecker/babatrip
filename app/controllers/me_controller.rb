class MeController < ApplicationController

  def show
    @profile = ProfileFacade.new(current_user)
  end

end
