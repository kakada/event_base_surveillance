class FieldSerializer < ActiveModel::Serializer
  attributes :name, :field_type, :mapping_field, :mapping_field_type, :display_order
end
