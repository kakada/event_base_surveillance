# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id, :value, :description, :location, :latitude,
             :longitude, :event_date, :report_date, :status,
             :risk_level, :source, :status

  belongs_to :event_type
  belongs_to :program
  has_many   :forms
  has_many   :field_values

  class EventTypeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
