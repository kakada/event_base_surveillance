# frozen_string_literal: true

class EventTypeShared < ApplicationRecord
  audited associated_with: :event_type

  belongs_to :event_type
  belongs_to :program
end
