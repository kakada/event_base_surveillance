# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return if user.nil?

    UserMailer.confirmation_instructions(user).deliver_now
  end
end
