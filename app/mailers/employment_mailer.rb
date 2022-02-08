class EmploymentMailer < ApplicationMailer
  def request_received
    @user = params[:user]
    mail(to: @user.email, subject: "Demande d’accès à votre planning de séances")
  end

  def request_accepted
    @employment = params[:employment]
    @enterprise = @employment.enterprise
    @user = @employment.employee
    mail(to: @user.email, subject: "Demande d'accès à un planning entreprise acceptée")
  end
end
