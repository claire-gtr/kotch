# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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
  email: "nico@gmail.com",
  password: 'password',
  first_name: 'nico',
  last_name: 'vandenbussche',
  admin: true)
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
test1 = User.new(
  email: "test1@gmail.com",
  password: 'password',
  first_name: 'test1',
  last_name: 'test',
  admin: true)
test1.save
test2 = User.new(
  email: "test2@gmail.com",
  password: 'password',
  first_name: 'test2',
  last_name: 'test',
  admin: true)
test2.save
test3 = User.new(
  email: "test3@gmail.com",
  password: 'password',
  first_name: 'test3',
  last_name: 'test',
  admin: true)
test3.save
test4 = User.new(
  email: "test4@gmail.com",
  password: 'password',
  first_name: 'test4',
  last_name: 'test',
  admin: true)
test4.save
test5 = User.new(
  email: "test5@gmail.com",
  password: 'password',
  first_name: 'test5',
  last_name: 'test',
  admin: true)
test5.save

coach = User.new(
  email: "coach@gmail.com",
  password: 'password',
  first_name: 'coach',
  last_name: 'sportif',
  coach: true)
coach.save

FriendRequest.create(requestor: test1, receiver: corentin)
FriendRequest.create(requestor: test2, receiver: corentin)
FriendRequest.create(requestor: corentin, receiver: test4)
FriendRequest.create(requestor: corentin, receiver: test3)
Friendship.create(friend_a: nico, friend_b: corentin)
