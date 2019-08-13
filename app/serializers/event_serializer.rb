# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id, :value, :description, :location, :latitude,
             :longitude, :event_date, :report_date, :status,
             :risk_level, :source, :status, :forms

  belongs_to :event_type
  belongs_to :program
  has_many   :field_values

  def forms
    customized_forms = []

    object.forms.each do |form|
      custom_form = form.attributes.except('form_type_id', 'created_at', 'updated_at')
      custom_form[:form_type] = form.form_type.slice(:id, :name)
      custom_form[:field_values] = form.field_values.collect do |field_value|
        fv = field_value.slice(:id, :field_id, :value, :values, :properties, :image, :file)
        fv[:field] = field_value.field.slice(:id, :name, :field_type)
        fv
      end
      customized_forms.push(custom_form)
    end

    customized_forms
  end

  class EventTypeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end