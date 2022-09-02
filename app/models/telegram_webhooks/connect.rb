# frozen_string_literal: true

module TelegramWebhooks
  class Connect < Base
    def process
      user.connect_telegram(chat) if user.present?

      reply(text_message)
    end

    private
      def user
        @user ||= User.from_telegram(message["phone_or_email"], message["province_name_or_code"])
      end

      def text_message
        return I18n.t("telegram_bot.congratulation_message", username: chat["first_name"], location: user.location.name_km) if user.present?

        I18n.t("telegram_bot.invalid_info_message", command: "connect", username: chat["first_name"])
      end
  end
end
