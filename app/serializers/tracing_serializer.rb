# frozen_string_literal: true

class TracingSerializer < ActiveModel::Serializer
  attributes :id, :field_id, :field_value, :properties, :traceable_id, :traceable_type, :created_date

  def created_date
    I18n.l(object.created_at, format: :y_m_d_h_mn)
  end
end
