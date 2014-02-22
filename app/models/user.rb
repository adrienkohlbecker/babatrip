class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validate :must_accept_terms

  has_many :trips

  BOX_SIZE_IN_METERS = 30000
  scope :near, ->(latitude, longitude, box_size=BOX_SIZE_IN_METERS) { where("earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(latitude, longitude)", latitude, longitude, box_size) }

  SEX_COLLECTION = ['Male', 'Female']
  RELATIONSHIP_STATUS_COLLECTION = ['Single', 'In a relationship']
  MOOD_COLLECTION = ['Hippie', 'Cool', 'Chic']
  TIME_COLLECTION = ['Day', 'Night', 'All day']

  MIN_PICTURE_HEIGHT = 100
  MIN_PICTURE_WIDTH = 100

  rails_admin do

    field :email
    field :uid do
      label 'Facebook ID'
      pretty_value do
        bindings[:view].tag(:a, { :href => "https://www.facebook.com/#{value}" }) << value << bindings[:view].tag('/a')
      end
    end
    field :latitude, :float
    field :longitude, :float

    field :created_at, :datetime
    field :last_sign_in_at, :datetime

  end

  def must_accept_terms

    if is_profile_completed and not accepts
      errors.add(:accepts, "Please accept our Terms of Service")
    end

  end


  def self.find_for_facebook_oauth(auth)

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

    user.email = auth.info.email unless user.is_email_overridden
    user.facebook_token = auth.credentials.token
    user.facebook_token_expires = Time.at(auth.credentials.expires_at)
    user.username = auth.info.nickname

    user.save!
    user

  end

  def after_facebook_auth

    if self.facebook_token_expires < Time.now
      Rails.logger.error "Token expired for user #{self.id} (expired at #{self.facebook_token_expires})"
      return
    end

    @graph = Koala::Facebook::API.new(self.facebook_token, ENV['FACEBOOK_APP_SECRET'])
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
                     user_uid: self.uid, friends_to_delete: friends_to_delete).delete_all
    end

    # Get user profile
    me = @graph.get_object("me", fields: 'birthday,gender,first_name,last_name,location,relationship_status,username')

    if me['location']
      location_id = me['location']['id']
      location = @graph.get_object(location_id, fields: 'location,name')
      lat = location['location']['latitude']
      long = location['location']['longitude']
      city = location['name']
    else
      lat = nil
      long = nil
      city = nil
    end

    sex = nil
    sex = 'Male' if me['gender'] == 'male'
    sex = 'Female' if me['gender'] == 'female'

    birth_date = Date.strptime(me['birthday'], '%m/%d/%Y') rescue nil
    username = me['username']

    first_name = me['first_name']
    last_name = me['last_name']

    relationship_status = nil
    relationship_status = 'Single' if ['Single', 'Widowed', 'Divorced', 'Separated'].include?(me['relationship_status'])
    relationship_status = 'In a relationship' if ['In a relationship', 'Engaged', 'Married', 'In a civil union', 'In a domestic partnership'].include?(me['relationship_status'])
    # manque "It's complicated" et "In an open relationship"

    self.update_attributes!(username: username, latitude: lat, longitude: long, sex: sex, birth_date: birth_date, first_name: first_name, last_name: last_name, relationship_status: relationship_status, city: city)

  end

  def full_name
    "#{first_name.try(:capitalize)} #{last_name.try(:capitalize)}".strip
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birth_date.year - (self.birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def picture_url(width: 100, height: 100)
    "https://graph.facebook.com/#{self.uid}/picture?width=#{width}&height=#{height}"
  end

  def friends
    User.joins("INNER JOIN connections ON (connections.this_id = '#{self.uid}' OR connections.other_id = '#{self.uid}')").where("(users.uid = connections.this_id OR users.uid = connections.other_id) AND users.uid != '#{self.uid}'")
  end

  def self.find_near_location(latitude, longitude, current_user)

    users_to_consider = ActiveRecord::Base.connection.execute %Q{

      SELECT users.id, users.mood, users.time,
        earth_distance(ll_to_earth(#{ActiveRecord::Base.connection.quote(latitude)}, #{ActiveRecord::Base.connection.quote(longitude)}), ll_to_earth(users.latitude, users.longitude)) AS distance
      FROM users
      WHERE
        (earth_box(ll_to_earth(#{ActiveRecord::Base.connection.quote(latitude)}, #{ActiveRecord::Base.connection.quote(longitude)}), #{BOX_SIZE_IN_METERS}) @> ll_to_earth(users.latitude, users.longitude))
        AND users.id != #{ActiveRecord::Base.connection.quote(current_user.id)}
    }

    ids_to_properties = {}
    users_to_consider.each {|r|

      match = 0
      if r['mood'] == current_user.mood
        match += 1
      end
      if r['time'] == current_user.time or r['time'] == 'All day' or current_user.time = 'All day'
        match += 1
      end

      ids_to_properties[r['id'].to_i] = {
        :distance => r['distance'],
        :mood => r['mood'],
        :time => r['time'],
        :match => match
      }

    }

    users = User.where(:id => ids_to_properties.keys).to_a
    users.sort_by! {|user| [-ids_to_properties[user.id][:match], ids_to_properties[user.id][:distance]] }

    return users

  end

  def is_a_friend_of?(other_user)
    return friends.include? other_user
  end

  def is_a_friend_of_friend_of?(other_user)
    friends_uids = friends.collect(&:uid)
    friends_of_friends = User.joins("INNER JOIN connections ON (connections.this_id IN ('#{friends_uids.join("','")}') AND users.uid = connections.other_id) OR (connections.other_id IN ('#{friends_uids.join("','")}') AND users.uid = connections.this_id)").where("users.uid NOT IN ('#{friends_uids.join("','")}') AND users.uid != '#{self.uid}'")
    return friends_of_friends.include? other_user
  end

  def male?
    sex == 'Male'
  end

end
