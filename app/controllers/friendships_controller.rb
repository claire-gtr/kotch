class FriendshipsController < ApplicationController

  def index
    @friendships = policy_scope(Friendship)
    @friend_request = FriendRequest.new
    @my_friend_requests_as_requestor = FriendRequest.where(requestor: current_user).where(status: "pending")
    @my_friend_requests_as_receiver = FriendRequest.where(receiver: current_user).where(status: "pending")
    @my_friends = current_user.friendships
  end
end
