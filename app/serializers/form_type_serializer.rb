# frozen_string_literal: true

class FormTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :event_type_id, :display_order

  has_many :fields
end
