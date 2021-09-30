class LessonMailer < ApplicationMailer
  def lesson_canceled
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de ta séance Koach & Co')
  end

  def new_user_inviation
    @user_email = params[:user_email]
    @lesson = params[:lesson]
    @friend = params[:friend]
    # @user = params[:user]
    # @temporay_password = params[:password]
    mail(to: @user_email, subject: 'Invitation à participer à une séance Koach & Co')
  end
end
