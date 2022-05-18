# frozen_string_literal: true

class EventShared < ApplicationRecord
  belongs_to :event
  belongs_to :program
end
