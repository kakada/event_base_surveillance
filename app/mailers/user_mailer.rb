# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: ENV['SETTINGS__SMTP__DEFAULT_FROM']

  def confirmation_instructions(user)
    @user = user
    mail(to: user.email, subject: t('mailer.confirmation_instruction'))
  end
end
