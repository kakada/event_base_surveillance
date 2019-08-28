# frozen_string_literal: true

class FieldSerializer < ActiveModel::Serializer
  attributes :id, :name, :field_type, :mapping_field, :mapping_field_type, :display_order
end
