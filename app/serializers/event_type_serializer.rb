# frozen_string_literal: true

class EventTypeSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :program
end
