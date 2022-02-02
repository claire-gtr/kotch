if Rails.env == 'production'

  puts 'It is forbidden !'

elsif Rails.env == 'development'

  puts 'cleaning database...'

  UserCode.destroy_all
  PromoCode.destroy_all
  Reason.destroy_all
  Partner.destroy_all
  PackOrder.destroy_all
  Subscription.destroy_all
  Answer.destroy_all
  Subject.destroy_all
  Location.destroy_all
  Message.destroy_all
  Booking.destroy_all
  Lesson.destroy_all
  Friendship.destroy_all
  FriendRequest.destroy_all
  User.destroy_all

  puts 'generating users...'

  claire = User.new(
    email: "clairegautier1809@gmail.com",
    password: 'password',
    first_name: 'claire',
    last_name: 'gautier',
    admin: true,
    coach: true,
    optin_cgv: true)
  claire.save

  nico = User.new(
    email: "nicolasvandenbussche0@gmail.com",
    password: 'password',
    first_name: 'nico',
    last_name: 'vandenbussche',
    optin_cgv: true)
  nico.save

  noemie = User.new(
    email: "noemie.vanhove@edhec.com",
    password: 'password',
    first_name: 'noemie',
    last_name: 'vanhove',
    admin: true,
    coach: true,
    optin_cgv: true)
  noemie.save

  corentin = User.new(
    email: "corentin.grandin@koachandco.com",
    password: 'password',
    first_name: 'corentin',
    last_name: 'grandin',
    admin: true,
    optin_cgv: true)
  corentin.save

  puts 'Done !'

end
