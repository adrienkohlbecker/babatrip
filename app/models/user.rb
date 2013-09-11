class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.find_for_facebook_oauth(auth)

    ap auth

    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    if not user
      user = User.where(:email => auth.info.email).first # Email must be unique so we handle this edge case
    end

    if not user
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20] # set a random password, password flow never used by user
    end

    user.email = auth.info.email
    user.facebook_token = auth.credentials.token
    user.facebook_token_expires = Time.at(auth.credentials.expires_at)

    user.save!
    user

  end

end
