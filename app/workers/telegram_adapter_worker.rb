# frozen_string_literal: true

class TelegramAdapterWorker
  include Sidekiq::Worker

  def perform(option = {})
    # What happen if sending fails
    ::TelegramBot.client_send_message(option["bot_token"], option["recipient"], option["message"])
  end
end
