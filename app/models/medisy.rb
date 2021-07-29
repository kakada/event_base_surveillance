# frozen_string_literal: true

# == Schema Information
#
# Table name: medisies
#
#  id         :bigint           not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :integer
#


class Medisy < ApplicationRecord
  belongs_to :program
  has_many :medisys_feeds, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true, format: { with: /\A((http|https):\/\/medisys.newsbrief.eu\/rss\/\?)/ix,
    message: 'must start with https://medisys.newsbrief.eu/rss/?' }
  validates :program_id, presence: true
end
