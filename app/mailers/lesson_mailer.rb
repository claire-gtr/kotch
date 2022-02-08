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
    mail(to: @user.email, subject: 'Annulation de séance')
  end

  def lesson_canceled_coach_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    @cancel_customer = params[:cancel_customer]
    mail(to: @user.email, subject: 'Annulation de séance')
  end

  def lesson_canceled_employee
    @user = params[:user]
    @lesson = params[:lesson]
    @enterprise = @lesson.enterprise
    mail(to: @user.email, subject: 'Annulation de séance')
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
    mail(to: @user.email, subject: "Ton entreprise t'invite à participer à une séance")
  end

  def enterprise_lessons_resume
    @user = params[:user]
    @lessons = params[:lessons]
    mail(to: @user.email, subject: 'Planning hebdomadaire des séances programmées par votre entreprise')
  end

  def coach_next_24h
    @user = params[:user]
    @lessons = params[:lessons]
    mail(to: @user.email, subject: 'Rappel de tes séances à venir')
  end

  def lesson_canceled_24h_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de séance')
  end
end
