class MedisysCategory < ApplicationRecord
  has_many :medisys_feeds_categories
  has_many :medisys_feeds, through: :medisys_feeds_categories
end
