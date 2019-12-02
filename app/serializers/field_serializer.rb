# frozen_string_literal: true

class FieldSerializer < ActiveModel::Serializer
  attributes :id, :name, :field_type, :mapping_field, :mapping_field_type,
             :display_order, :type, :label, :code

  def type
    object.class.es_datatype
  end

  def label
    object.name
  end
end
