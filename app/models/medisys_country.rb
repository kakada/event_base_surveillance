class MedisysCountry < ApplicationRecord
  has_many :medisys_feeds

  mount_uploader :image, ImageUploader
end
