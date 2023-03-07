# frozen_string_literal: true

module Events
  module ShareStatus
    extend ActiveSupport::Concern

    included do
      def shared_with?(program_id)
        program_shared_ids.include?(program_id)
      end

      # we want to know if the event is shared to other?
      def shared_out?(program_id)
        program_shared_ids.present? && program_shared_ids.exclude?(program_id)
      end
    end
  end
end
