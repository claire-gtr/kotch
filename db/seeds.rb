# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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
User.destroy_all

claire = User.new(
  email: "clairegautier1809@gmail.com",
  password: 'password',
  first_name: 'claire',
  last_name: 'gautier',
  admin: true,
  coach: true)
claire.save

nico = User.new(
  email: "nicolasvandenbussche0@gmail.com",
  password: 'password',
  first_name: 'nico',
  last_name: 'vandenbussche')
nico.save

noemie = User.new(
  email: "noemie.vanhove@edhec.com",
  password: 'password',
  first_name: 'noemie',
  last_name: 'vanhove',
  admin: true,
  coach: true)
noemie.save

corentin = User.new(
  email: "corentin.grandin@koachandco.com",
  password: 'password',
  first_name: 'corentin',
  last_name: 'grandin',
  admin: true)
corentin.save
