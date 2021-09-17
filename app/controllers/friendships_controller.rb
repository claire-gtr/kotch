class FriendshipsController < ApplicationController

  def index
    @friendships = policy_scope(Friendship)
    @friend_request = FriendRequest.new
    @my_friend_requests_as_requestor = FriendRequest.where(requestor: current_user).where(status: "pending")
    @my_friend_requests_as_receiver = FriendRequest.where(receiver: current_user).where(status: "pending")

    if params[:friends_query].present?
      @my_friends = current_user.friendships.select do |friendship|
        friendship.friend_a.first_name.downcase == params[:friend_query].downcase || 
        friendship.friend_b.first_name.downcase == params[:friend_query].downcase ||
        friendship.friend_a.last_name.downcase == params[:friend_query].downcase || 
        friendship.friend_b.last_name.downcase == params[:friend_query].downcase
      end
    else 
      @my_friends = current_user.friendships
    end

    if params[:email].present?
      @new_friends = User.all.select do |user|
        user.email.downcase == params[:email].downcase      
      end
    else
      @new_friends = []
    end
  end
end
