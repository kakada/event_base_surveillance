class Location < ApplicationRecord
  validates :code, :name_en, :name_km, :kind, presence: true
  validates_inclusion_of :kind, in: %w(province district commune village), message: "type %{value} is not included in location types"

  has_many :children, class_name: 'Location', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Location', optional: true
end
