# frozen_string_literal: true

module Users
  module ThirdPartyNotification
    extend ActiveSupport::Concern

    included do
      def disconnect_telegram
        notify(Notifiers::AccountOwnerTelegramNotifier.new(self), "telegram")
        notify(program_telegram_notifier("disconnect"), "telegram")

        self.update(telegram_chat_id: nil, telegram_username: nil)
      end

      def connect_telegram(chat = {})
        self.update(telegram_chat_id: chat["id"], telegram_username: chat["first_name"])

        notify(program_telegram_notifier("connect"), "telegram")
      end

      private
        def program_telegram_notifier(action = "connect")
          Notifiers::ReceiveProgramNotificationTelegramNotifier.new(self, action)
        end
    end
  end
end
