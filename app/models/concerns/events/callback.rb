# frozen_string_literal: true

module Events
  module Callback
    extend ActiveSupport::Concern

    included do
      after_create  :notify_third_party, if: :enable_worker?
      after_save    :create_document, if: :enable_worker?
      after_destroy :delete_document, if: :enable_worker?

      private

      def event_id
        try(:uuid) || try(:event_uuid)
      end

      def create_document
        IndexerWorker.perform_async(:index, event_id, program_id)
      end

      def delete_document
        IndexerWorker.perform_async(:delete, event_id, program_id)
      end

      def enable_worker?
        ENV['ENABLE_EVENT_WORKER'] == 'true'
      end

      def notify_third_party
        TelegramWorker.perform_async(id, self.class.to_s)

        event_type.webhooks.each do |webhook|
          WebhookWorker.perform_async(webhook.id, event_id)
        end
      end
    end
  end
end
