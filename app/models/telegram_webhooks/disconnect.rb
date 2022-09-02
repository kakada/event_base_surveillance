# frozen_string_literal: true

module TelegramWebhooks
  class Disconnect < Base
    def process
      user.update(telegram_chat_id: nil, telegram_username: nil) if user.present?

      reply(text_message)
    end

    private
      def user
        @user ||= User.from_telegram(message["phone_or_email"], message["province_name_or_code"])
      end

      def text_message
        return I18n.t("telegram_bot.disconnect_message", username: chat["first_name"], location: user.location.name_km) if user.present?

        I18n.t("telegram_bot.invalid_info_message", command: "disconnect", username: chat["first_name"])
      end
  end
end
