# frozen_string_literal: true

# == Schema Information
#
# Table name: tracings
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  field_value    :string
#  properties     :text
#  traceable_id   :string
#  traceable_type :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Tracing < ApplicationRecord
  belongs_to :traceable, polymorphic: true
  serialize :properties, Hash

  scope :number, -> { where(type: 'Tracings::NumberTracing') }
  scope :text, -> { where(type: 'Tracings::TextTracing') }
end
