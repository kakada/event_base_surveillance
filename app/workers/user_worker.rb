# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    return if user.nil?

    user.send_confirmation_instructions
  end
end
