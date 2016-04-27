# Load the Rails application.
require File.expand_path('../application', __FILE__)

# mandrill heroku addon
ActionMailer::Base.smtp_settings = {
    :port =>           '587',
    :address =>        'smtp.sendgrid.net',
    :user_name =>      ENV['SENDGRID_USERNAME'],
    :password =>       ENV['SENDGRID_PASSWORD'],
    :domain =>         'travel-meet.com',
    :authentication => :plain,
    :enable_starttls_auto => true
}
ActionMailer::Base.delivery_method = :smtp

# Initialize the Rails application.
TravelMeet::Application.initialize!
