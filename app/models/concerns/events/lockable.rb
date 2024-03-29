# frozen_string_literal: true

module Events
  module Lockable
    extend ActiveSupport::Concern

    included do
      def locked?
        close? && lockable_at.nil?
      end

      def unlockable?
        locked?
      end

      def unlock_access!
        self.lockable_at = program.unlock_event_duration.days.from_now.to_date
        self.save(validate: false)
      end
    end
  end
end
