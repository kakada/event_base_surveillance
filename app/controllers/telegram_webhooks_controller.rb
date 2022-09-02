# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def message(message)
    add_job("Message", message)
  end

  # First start with bot
  def start!(word = nil, *other_words)
    add_job("Start", { "chat" => chat })
  end

  # /connect 011222333 120101
  # /connect 011222333 place_name
  # /connect phone_number_or_email province_name_or_code
  def connect!(phone_or_email = nil, *province_name_or_code)
    add_job("Connect", { "chat" => chat, "phone_or_email" => phone_or_email, "province_name_or_code" => province_name_or_code.join(" ") })
  end

  # /disconnect 011222333 120101
  # /disconnect 011222333 place_name
  # /disconnect phone_number_or_email province_name_or_code
  def disconnect!(phone_or_email = nil, *province_name_or_code)
    add_job("Disconnect", { "chat" => chat, "phone_or_email" => phone_or_email, "province_name_or_code" => province_name_or_code.join(" ") })
  end

  private
    def add_job(klass_name, message = {})
      TelegramWebhookWorker.perform_async(klass_name, message)
    end
end
