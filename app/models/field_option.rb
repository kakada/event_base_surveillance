# frozen_string_literal: true

# == Schema Information
#
# Table name: field_options
#
#  id         :bigint           not null, primary key
#  field_id   :integer
#  name       :string
#  value      :string
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldOption < ApplicationRecord
  belongs_to :field

  # Validation
  validates :value, :name, presence: true, uniqueness: { scope: [:field_id] }
  before_validation :set_option_value, if: -> { name.present? }

  private

  def set_option_value
    self.value = (value.presence || name).downcase.split(' ').join('_')
  end
end
