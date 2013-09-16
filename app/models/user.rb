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

  def after_facebook_auth

    if self.facebook_token_expires < Time.now
      Rails.logger.error "Token expired for user #{self.id} (expired at #{self.facebook_token_expires})"
      return
    end

    @graph = Koala::Facebook::API.new(self.facebook_token)
    friends = @graph.get_connections("me", "friends")
    friends_uids = friends.collect{|f| f["id"]}

    # Get current friends
    current_connections = Connection.where('this_id = :user_uid OR other_id = :user_uid', user_uid: self.uid)
    current_friends_uids = current_connections.collect{|c| [c.this_id, c.other_id]}.flatten.uniq - [self.uid]

    # Add new friends
    friends_to_add = friends_uids - current_friends_uids
    friends_to_add.each do |uid|
      Connection.create(this_id: self.uid, other_id: uid)
    end

    # Delete obsolete friends
    friends_to_delete = current_friends_uids - friends_uids
    if friends_to_delete.any?
      Connection.where('(this_id =  :user_uid AND other_id IN (:friends_to_delete))
                     OR (other_id = :user_uid AND this_id  IN (:friends_to_delete))',
                     user_uid: self.uid, friends_uids: friends_uids).delete_all
    end

  end

end
