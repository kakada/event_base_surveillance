# frozen_string_literal: true

module EventMilestones
  module RelevantEventMilestone
    extend ActiveSupport::Concern

    included do
      def relevant_event_milestone(relevant_milestone_id)
        return previous_event_milestone if relevant_milestone_id == Milestone::PREVIOUS_MILESTONE

        event_milestones.select { |em| em.milestone_id == relevant_milestone_id.to_i }.first
      end

      def previous_event_milestone
        index = event_milestones.index{ |em| em.milestone_id == milestone_id }

        event_milestones[0..index].last(2).first
      end

      private
        def event_milestones
          @event_milestones ||= all_event_milestones.sort_by { |em|
            program.milestone_ids.index(em.milestone_id)
          }
        end

        def all_event_milestones
          scope = [event] + event.event_milestones
          scope += [self] if self.new_record?
          scope
        end
    end
  end
end
