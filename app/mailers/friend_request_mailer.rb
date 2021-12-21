class FriendRequestMailer < ApplicationMailer
  def friend_request_send
    friend_request = params[:friend_request]
    @requestor = friend_request.requestor
    @receiver = friend_request.receiver
    @user = @receiver
    mail(to: @receiver.email, subject: "Demande d'amitié sur Koach & Co")
  end
end
