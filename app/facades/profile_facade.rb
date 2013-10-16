class ProfileFacade

  def initialize(user)
    @user = user
  end

  def edit_content_title
    @user.is_profile_completed ? 'Edit your profile' : 'Complete your profile'
  end

  def user
    @user
  end

end
