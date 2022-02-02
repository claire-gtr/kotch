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

  def lesson_canceled_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Confirmation d’annulation de séance')
  end

  def lesson_canceled_coach_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    @cancel_customer = params[:cancel_customer]
    mail(to: @user.email, subject: 'Confirmation d’annulation de séance entreprise')
  end

  def lesson_canceled_employee
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: "Confirmation d’annulation d'une séance de votre entreprise")
  end

  def new_user_inviation
    @user_email = params[:user_email]
    @lesson = params[:lesson]
    @friend = params[:friend]
    @user = User.new
    mail(to: @user_email, subject: 'Invitation à participer à une séance Koach & Co')
  end

  def invite_employee
    @lesson = params[:lesson]
    @user = params[:user]
    @enterprise = params[:enterprise]
    mail(to: @user.email, subject: 'Votre entreprise vous invite à participer à une séance Koach & Co')
  end

  def enterprise_lessons_resume
    @user = params[:user]
    @lessons = params[:lessons]
    mail(to: @user.email, subject: 'Récapitulatif des séances de ton entreprise la semaine prochaine')
  end

  def coach_next_24h
    @user = params[:user]
    @lessons = params[:lessons]
    mail(to: @user.email, subject: 'Récapitulatif de tes séances des prochaines 24 heures')
  end

  def lesson_canceled_24h_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de séance faute de coach')
  end
end
