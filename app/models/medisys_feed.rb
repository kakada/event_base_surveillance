# frozen_string_literal: true

# == Schema Information
#
# Table name: medisys_feeds
#
#  id                 :bigint           not null, primary key
#  category_trigger   :string
#  description        :string
#  fail_reason        :string
#  georss_point       :string
#  guid               :string
#  iso_language       :string
#  keywords           :string
#  link               :string
#  pub_date           :datetime
#  source_name        :string
#  source_url         :string
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  medisy_id          :integer
#  medisys_country_id :integer
#  program_id         :integer
#


include ActionView::Helpers::DateHelper

class MedisysFeed < ApplicationRecord
  belongs_to :medisy
  belongs_to :medisys_country
  has_many :medisys_feeds_categories
  has_many :medisys_categories, through: :medisys_feeds_categories

  validates :title, presence: true
  validates :link, presence: true

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
    scope = scope.where("pub_date BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    scope
  end
end
