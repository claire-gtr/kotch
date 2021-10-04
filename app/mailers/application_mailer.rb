class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL']
  layout 'mailer'

  # helpers
  include ReasonHelper
end
