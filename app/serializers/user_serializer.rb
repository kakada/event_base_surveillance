# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :province, :email, :value

  def province
    object.location.try("name_#{I18n.locale}")
  end

  def name
    object.full_name
  end

  def value
    object.id
  end
end
