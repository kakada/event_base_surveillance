class UserMailer < ApplicationMailer
  default from: ENV['SETTINGS__SMTP__DEFAULT_FROM']

  def confirmation_instructions(user)
    @user = user
    mail(to: user.email, subject: 'Confirmation Instruction')
  end
end
