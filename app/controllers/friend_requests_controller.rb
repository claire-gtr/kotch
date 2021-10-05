class FriendRequestsController < ApplicationController

  def create
    email = params[:friend_email].gsub(/\s+/, '').downcase
    user = User.find_by(email: email)
    friend_request = FriendRequest.new
    authorize friend_request
    if user == current_user || current_user.coach
      flash[:alert] = "Vous ne pouvez pas effectuer cette action."
      redirect_to friendships_path
    else
      if user
        if Friendship.where(friend_a: user, friend_b: current_user).any? || Friendship.where(friend_a: current_user, friend_b: user).any? || FriendRequest.where(requestor: user, receiver: current_user).any?
          flash[:notice] = "Il y a déjà une demande d'amitié entre vous et #{email}"
          redirect_to friendships_path
        else
          friend_request = FriendRequest.new(requestor: current_user, receiver: user)
          friend_request.save
          flash[:notice] = "Une demande d'amitié a bien été envoyé à #{email}"
          redirect_to friendships_path
        end
      else
        @friendships = policy_scope(Friendship)
        @friend_request = FriendRequest.new
        @my_friend_requests_as_requestor = FriendRequest.where(requestor: current_user).where(status: "pending")
        @my_friend_requests_as_receiver = FriendRequest.where(receiver: current_user).where(status: "pending")
        @my_friends = current_user.friendships
        render 'friendships/index'
        flash[:alert] = "Cet email ne correspond à aucun des utilisateurs de Koach & Co."
      end
    end
  end

  def update
    @friend_request = FriendRequest.find(params[:id])
    authorize @friend_request
    if params[:query] == "accept"
      @friend_request.status = "accepted"
      @friend_request.save
      @friendship = Friendship.new(friend_a_id: @friend_request.requestor.id, friend_b_id: current_user.id)
      @friendship.save
    elsif params[:query] == 'reject'
      @friend_request.destroy
    end
    redirect_to friendships_path
  end
end
