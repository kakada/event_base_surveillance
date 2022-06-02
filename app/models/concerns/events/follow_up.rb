# frozen_string_literal: true

module Events
  module FollowUp
    extend ActiveSupport::Concern

    included do
      def send_notification_async(schedule_id)
        EventFollowUpWorker.perform_async(id, schedule_id)
      end

      def notify_email(message)
        title = "CamEMS follow up case: #{event_id}"

        NotificationMailer.notify(creator.email, message, title).deliver_now
      end

      def notify_telegram(message)
        return unless creator.telegram?

        TelegramBot.send_message(creator.telegram_chat_id, message)
      end

      # Class method
      def self.reached_intervals(duration_in_day)
        where("(NOW()::Date - updated_at::Date) > 0 AND (NOW()::Date - updated_at::Date) % ? = 0", duration_in_day)
      end
    end
  end
end
