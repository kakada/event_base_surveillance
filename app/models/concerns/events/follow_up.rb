# frozen_string_literal: true

module Events
  module FollowUp
    extend ActiveSupport::Concern

    included do
      # Class method
      def self.reached_intervals(duration_in_day)
        where("(NOW()::Date - updated_at::Date) > 0 AND (NOW()::Date - updated_at::Date) % ? = 0", duration_in_day)
      end
    end
  end
end
