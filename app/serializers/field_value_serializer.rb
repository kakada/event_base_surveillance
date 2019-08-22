# frozen_string_literal: true

class FieldValueSerializer < ActiveModel::Serializer
  attributes :id, :field_id, :value, :values, :properties, :image, :file
end
