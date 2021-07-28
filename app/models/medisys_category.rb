# frozen_string_literal: true

# == Schema Information
#
# Table name: medisys_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class MedisysCategory < ApplicationRecord
  has_many :medisys_feeds_categories
  has_many :medisys_feeds, through: :medisys_feeds_categories
end
