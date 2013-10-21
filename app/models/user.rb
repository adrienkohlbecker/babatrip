class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  SEX_COLLECTION = [['Male', 'M'] ,['Female', 'F']]
  RELATIONSHIP_STATUS_COLLECTION = [['Single', 'S'], ['In a relationship', 'R']]
  MOOD_COLLECTION = [['Hippie', 'H'], ['Normal', 'N'], ['Chic', 'C']]
  TIME_COLLECTION = [['Night', 'N'], ['Day', 'D'], ['24h', 'A']]

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

    user.email = auth.info.email unless user.is_email_overridden
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
                     user_uid: self.uid, friends_to_delete: friends_to_delete).delete_all
    end

    # Get user profile
    me = @graph.get_object("me", fields: 'birthday,gender,first_name,last_name,location,relationship_status')

    location_id = me['location']['id']
    location = @graph.get_object(location_id, fields: 'location,name')
    lat = location['location']['latitude']
    long = location['location']['longitude']
    city = location['name']

    sex = nil
    sex = 'M' if me['gender'] == 'male'
    sex = 'F' if me['gender'] == 'female'

    birth_date = Date.strptime(me['birthday'], '%m/%d/%Y') rescue nil

    first_name = me['first_name']
    last_name = me['last_name']

    relationship_status = nil
    relationship_status = 'S' if ['Single', 'Widowed', 'Divorced', 'Separated'].include?(me['relationship_status'])
    relationship_status = 'R' if ['In a relationship', 'Engaged', 'Married', 'In a civil union', 'In a domestic partnership'].include?(me['relationship_status'])
    # manque "It's complicated" et "In an open relationship"

    self.update_attributes!(latitude: lat, longitude: long, sex: sex, birth_date: birth_date, first_name: first_name, last_name: last_name, relationship_status: relationship_status, city: city, picture_url: picture_url)

  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def picture_url(width: 100, height: 100)
    "https://graph.facebook.com/#{self.uid}/picture?width=#{width}&height=#{height}"
  end

end
