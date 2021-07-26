include ActionView::Helpers::DateHelper

class MedisysFeed < ApplicationRecord
  belongs_to :medisy
  belongs_to :medisys_country
  has_many :medisys_feeds_categories
  has_many :medisys_categories, through: :medisys_feeds_categories

  accepts_nested_attributes_for :medisys_categories

  def medisys_categories_attributes=(attributes)
    attributes.each do |attribute|
      category = MedisysCategory.find_or_create_by(name: attribute[:name])
      medisys_categories << category unless medisys_categories.include? category
    end
  end

  def time_ago
    distance_of_time_in_words(Time.zone.now, pub_date)
  end

  def self.filter(params)
    scope = all
    scope = scope.where(medisy_id: params[:medisy_id]) if params[:medisy_id].present?
    scope = scope.where('pub_date >= ?', params[:start_date]) if params[:start_date].present?
    scope
  end
end
