class MedisysFeedsCategory < ApplicationRecord
  belongs_to :medisys_feed
  belongs_to :medisys_category
end
