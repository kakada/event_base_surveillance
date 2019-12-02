# frozen_string_literal: true

class EventMilestoneSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :submitter_id, :conducted_at, :created_at, :updated_at

  belongs_to :milestone
  has_many   :field_values

  class MilestoneSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
