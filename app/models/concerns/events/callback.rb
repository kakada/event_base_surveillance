# frozen_string_literal: true

module Events
  module Callback
    extend ActiveSupport::Concern

    included do
      after_commit  :notify_third_party, on: :create, if: :enable_worker?
      after_commit  :create_document, on: [:create, :update], if: :enable_worker?
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
          ::Message::CHANNELS.each do |channel|
            notify("Notifiers::EventMilestone#{channel.titlecase}Notifier".constantize.new(self), channel)
          end

          event_type.webhooks.each do |webhook|
            next unless webhook.active?

            WebhookWorker.perform_async(webhook.id, event_id)
          end
        end
    end
  end
end
