# frozen_string_literal: true

module Samples
  class EventType
    def self.load
      event_types = [
        {
          name: 'Unknown',
          user_id: ::User.find_by(email: 'cdc@program.org').id,
          color: "##{SecureRandom.hex(3)}",
          default: true
        },
        {
          name: 'Influenza',
          user_id: ::User.find_by(email: 'cdc@program.org').id,
          color: "##{SecureRandom.hex(3)}"
        }
      ]

      event_types.each do |obj|
        ::EventType.create(obj)
      end
    end
  end
end
