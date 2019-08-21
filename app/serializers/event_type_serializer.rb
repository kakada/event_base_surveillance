# frozen_string_literal: true

class EventTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :form_types

  belongs_to :program
  has_many   :fields

  # https://stackoverflow.com/questions/32079897/serializing-deeply-nested-associations-with-active-model-serializers
  def form_types
    customized_form_types = []

    object.form_types.each do |form_type|
      custom_form_type = form_type.attributes
      custom_form_type[:fields] = form_type.fields.collect{ |field|
        field.slice(:id, :name, :field_type, :mapping_field, :mapping_field_type, :display_order)}
      customized_form_types.push(custom_form_type)
    end

    customized_form_types
  end
end
