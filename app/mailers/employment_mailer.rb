class EmploymentMailer < ApplicationMailer
  def request_received
    @user = params[:enterprise]
    @employee = params[:employee]
    mail(to: @user.email, subject: "Demande d'accès à votre planning Koach & Co")
  end

  def request_accepted
    @employment = params[:employment]
    @enterprise = @employment.enterprise
    @user = @employment.employee
    mail(to: @user.email, subject: "Demande d'accès à un planning entreprise acceptée")
  end
end
