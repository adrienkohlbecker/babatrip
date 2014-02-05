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

  def trips
    @user.trips
  end

  def picture_url
    @user.picture_url
  end

  def is_signup?
    !@user.is_profile_completed
  end

end
