# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  field_type         :string
#  required           :boolean
#  mapping_field      :string
#  mapping_field_type :string
#  display_order      :integer
#  fieldable_type     :string
#  fieldable_id       :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Field < ApplicationRecord
  FIELD_TYPES = %w[text integer date select_one select_multiple note image location mapping_field].freeze

  belongs_to :fieldable, polymorphic: true
  has_many   :field_options, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: %i[fieldable_id fieldable_type], message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }

  default_scope { order(display_order: :asc) }

  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }
end
