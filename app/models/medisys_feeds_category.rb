# frozen_string_literal: true

# == Schema Information
#
# Table name: medisys_feeds_categories
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  medisys_category_id :integer
#  medisys_feed_id     :integer
#


class MedisysFeedsCategory < ApplicationRecord
  belongs_to :medisys_feed
  belongs_to :medisys_category
end
