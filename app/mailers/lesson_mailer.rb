class LessonMailer < ApplicationMailer
  def lesson_canceled
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de réservation de ta séance Koach & Co')
  end
end
