# frozen_string_literal: true

class FormSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :submitter_id, :conducted_at, :priority,
             :source, :created_at, :updated_at

  belongs_to :form_type
  has_many   :field_values

  class FormTypeSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
