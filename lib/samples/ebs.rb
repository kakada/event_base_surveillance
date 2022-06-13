# frozen_string_literal: true

require_relative "program"
require_relative "milestone"
require_relative "user"
require_relative "event_type"
require_relative "location"
require_relative "event"

module Samples
  class Ebs
    def self.load
      ::Samples::Program.load
      ::Samples::User.load
      ::Samples::EventType.load
      ::Samples::Milestone.load
      ::Samples::Location.load
      ::Samples::Event.load
    end
  end
end
