class LessonMailer < ApplicationMailer
  def lesson_canceled
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de ta séance Koach & Co')
  end

  def lesson_canceled_creator
    @user = params[:user]
    @lesson = params[:lesson]
    @cancel_customer = params[:cancel_customer]
    mail(to: @user.email, subject: 'Confirmation d’annulation de séance')
  end

  def lesson_canceled_customer
    @user = params[:user]
    @lesson = params[:lesson]
    @cancel_customer = params[:cancel_customer]
    mail(to: @user.email, subject: 'Annulation de séance')
  end

  def lesson_canceled_coach
    @user = params[:user]
    @lesson = params[:lesson]
    @cancel_customer = params[:cancel_customer]
    mail(to: @user.email, subject: 'Confirmation d’annulation de séance')
  end

  def new_user_inviation
    @user_email = params[:user_email]
    @lesson = params[:lesson]
    @friend = params[:friend]
    @user = User.new
    # @user = params[:user]
    # @temporay_password = params[:password]
    mail(to: @user_email, subject: 'Invitation à participer à une séance Koach & Co')
  end

  def invite_employee
    @lesson = params[:lesson]
    @user = params[:user]
    @enterprise = params[:enterprise]
    mail(to: @user.email, subject: 'Votre entreprise vous invite à participer à une séance Koach & Co')
  end
end
