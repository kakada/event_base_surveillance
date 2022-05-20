# frozen_string_literal: true

module Events
  module IntervalFollowUp
    extend ActiveSupport::Concern

    included do
      def send_notification_async
        IntervalFollowUpEventWorker.perform_async(id)
      end

      def notify_email
        title = "CamEMS follow up case: #{event_id}"

        NotificationMailer.notify(creator.email, follow_up_message, title).deliver_now
      end

      def notify_telegram
        return unless creator.telegram?

        TelegramBot.send_message(creator.telegram_chat_id, follow_up_message)
      end

      def follow_up_message
        @follow_up_message ||= program.interval_follow_up.message
                                      .gsub(/\{\{event.uuid\}\}/, uuid)
                                      .gsub(/\{\{event.progress\}\}/, progress)
      end

      # Class method
      def self.reached_intervals(duration_in_day)
        self.no_lockeds.where("(NOW()::Date - updated_at::Date) > 0 AND (NOW()::Date - updated_at::Date) % ? = 0", duration_in_day)
      end
    end
  end
end
