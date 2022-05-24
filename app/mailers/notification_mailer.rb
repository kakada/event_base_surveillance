# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify(emails, body_message, title=nil)
    @body_message = body_message
    mail(to: emails, subject: title || 'EBS Notification')
  end
end
