# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id, :number_of_case, :number_of_death, :description, :location, :latitude,
             :longitude, :event_date, :report_date, :status,
             :risk_level, :source, :status, :event_milestones

  belongs_to :event_type
  belongs_to :program
  has_many   :field_values

  def event_milestones
    customized_event_milestones = []

    object.event_milestones.each do |event_milestone|
      custom_milestone = event_milestone.attributes.except('milestone_id', 'created_at', 'updated_at')
      custom_milestone[:milestone] = event_milestone.milestone.slice(:id, :name)
      custom_milestone[:field_values] = event_milestone.field_values.collect do |field_value|
        fv = field_value.slice(:id, :field_id, :value, :values, :properties, :image, :file)
        fv[:field] = field_value.field.slice(:id, :name, :field_type)
        fv
      end
      customized_event_milestones.push(custom_milestone)
    end

    customized_event_milestones
  end

  class EventTypeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
