# frozen_string_literal: true

module Samples
  class EventType
    def self.load
      event_types = [
        {
          name: 'Influenza',
          user_id: ::User.find_by(email: 'cdc@program.org').id,
          color: "##{SecureRandom.hex(3)}"
        },
        {
          name: 'H5N1',
          user_id: ::User.find_by(email: 'cdc@program.org').id,
          color: "##{SecureRandom.hex(3)}",
          shared: true
        },
        {
          name: 'ប៉េសជ្រូកអាហ្រ្វិក',
          user_id: ::User.find_by(email: 'gdaph@program.org').id,
          color: "##{SecureRandom.hex(3)}"
        }
      ]

      event_types.each do |obj|
        ::EventType.create(obj)
      end
    end
  end
end
