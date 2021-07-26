class Medisy < ApplicationRecord
  belongs_to :program
  has_many :medisys_feeds, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true
  validates :program_id, presence: true
end
