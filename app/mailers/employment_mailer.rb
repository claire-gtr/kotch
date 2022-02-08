class EmploymentMailer < ApplicationMailer
  def request_received
    @user = params[:user]
    mail(to: @user.email, subject: "Demande d’accès à votre planning de séances")
  end

  def request_accepted
    @employment = params[:employment]
    @user = @employment.employee
    mail(to: @user.email, subject: 'Accès au planning de mon entreprise')
  end
end
