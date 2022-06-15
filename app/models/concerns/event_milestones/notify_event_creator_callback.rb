# frozen_string_literal: true

module EventMilestones
  module NotifyEventCreatorCallback
    extend ActiveSupport::Concern

    included do
      after_create_commit :notify_that_milestone_created_async, unless: -> { event.creator_id == submitter_id  }
      after_update_commit :notify_that_milestone_updated_async, unless: -> { event.creator_id == submitter_id  }

      private
        def notify_that_milestone_created_async
          message = "Event {{event_uuid}}, there is a new milestone('{{milestone_name}}') has been created by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS"

          notify_creator_async(message)
        end

        def notify_that_milestone_updated_async
          message = "Event {{event_uuid}} in {{milestone_name}} milestone is being modified by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS"

          notify_creator_async(message)
        end

        def notify_creator_async(message)
          event.creator.notification_channels.each do |channel|
            notify("Notifiers::EventCreator#{channel.titlecase}Notifier".constantize.new(self, message), channel)
          end
        end
    end
  end
end
