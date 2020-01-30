# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['SETTINGS__SMTP__DEFAULT_FROM']
  layout 'mailer'
end
