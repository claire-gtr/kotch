class EmploymentMailer < ApplicationMailer
  def request_received
    @enterprise = params[:enterprise]
    @employee = params[:lesson]
    mail(to: @enterprise.email, subject: "Demande d'accès à votre planning Koach & Co")
  end

  def request_accepted
    @employment = params[:employment]
    @enterprise = @employment.enterprise
    @employee = @employment.employee
    mail(to: @employee.email, subject: "Demande d'accès à un planning entreprise acceptée")
  end
end
