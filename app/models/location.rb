class Location < ApplicationRecord
  validates :code, :name_en, :name_km, :kind, presence: true
  validates_inclusion_of :kind, in: %w(province district commune village), message: "type %{value} is not included in location types"
  validate :geopoint_within_range

  has_many :children, class_name: 'Location', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Location', optional: true


  private
  def geopoint_within_range
    return if geopoint.nil?
    unless geopoint.x.between?(-90,90) && geopoint.y.between?(-180,180)
      errors.add :geopoint, 'is invalid'
    end
  end
end
