# frozen_string_literal: true

# == Schema Information
#
# Table name: medisys_countries
#
#  id         :bigint           not null, primary key
#  code       :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class MedisysCountry < ApplicationRecord
  has_many :medisys_feeds

  mount_uploader :image, ImageUploader
end
