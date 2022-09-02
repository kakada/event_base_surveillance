# frozen_string_literal: true

module TelegramWebhooks
  class Base
    attr_reader :message
    attr_reader :chat

    def initialize(message = {})
      @message = message
      @chat = message["chat"]

      I18n.locale = :km
    end

    def process
      raise "Should implement in sub class!"
    end

    private
      def reply(text_message)
        ::TelegramBot.client_send_message(::TelegramBot.system_bot_token, chat["id"], text_message)
      end
  end
end
