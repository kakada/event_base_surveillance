# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation_instructions(user)
    @user = user
    mail(to: user.email, subject: t("mailer.confirmation_instruction"))
  end
end
