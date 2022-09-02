# frozen_string_literal: true

module TelegramWebhooks
  class Start < Base
    def process
      reply(text_message)
    end

    private
      def text_message
        I18n.t("telegram_bot.welcome_message", username: chat["first_name"])
      end
  end
end
