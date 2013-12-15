class UserMailer < ActionMailer::Base
  default from: "Travel Meet <contact@travel-meet.com>"

  def message_from_trip(sender, trip, message)
    @sender = sender
    @receiver = trip.user
    @trip = trip
    @message = message

    mail(to: @receiver.email, reply_to: @sender.email, subject: "New message from #{sender.full_name}")
  end

  def message_from_profile(sender, receiver, message)
    @sender = sender
    @receiver = receiver
    @message = message

    mail(to: @receiver.email, reply_to: @sender.email, subject: "New message from #{sender.full_name}")
  end
end
