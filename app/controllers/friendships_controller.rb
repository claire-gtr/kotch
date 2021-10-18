class FriendshipsController < ApplicationController

  def index
    @friendships = policy_scope(Friendship)
    @friend_request = FriendRequest.new
    @my_friend_requests_as_requestor = FriendRequest.where(requestor: current_user).where(status: "pending")
    @my_friend_requests_as_receiver = FriendRequest.where(receiver: current_user).where(status: "pending")

    if params[:friend_query].present?
      @my_friends = current_user.friendships.select do |friendship|
        friendship.friend_a.first_name.downcase == params[:friend_query].downcase.gsub(/\s+/, '') ||
        friendship.friend_b.first_name.downcase == params[:friend_query].downcase.gsub(/\s+/, '') ||
        friendship.friend_a.last_name.downcase == params[:friend_query].downcase.gsub(/\s+/, '') ||
        friendship.friend_b.last_name.downcase == params[:friend_query].downcase.gsub(/\s+/, '')
      end
    else
      @my_friends = current_user.friendships
    end

    if params[:email].present?
      @new_friends = User.all.select do |user|
        user.email.downcase == params[:email].downcase.gsub(/\s+/, '')
      end
    elsif params[:first_name].present? && params[:last_name].present?
      @new_friends = User.all.select do |user|
        (user.first_name.downcase == params[:first_name].downcase).gsub(/\s+/, '') &&
        (user.last_name.downcase == params[:last_name].downcase).gsub(/\s+/, '')
      end
    else
      @new_friends = []
    end
  end
end
