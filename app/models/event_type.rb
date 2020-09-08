# frozen_string_literal: true

# == Schema Information
#
# Table name: event_types
#
#  id         :bigint           not null, primary key
#  code       :string
#  color      :string
#  default    :boolean          default(FALSE)
#  guideline  :string
#  name       :string           not null
#  shared     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :integer
#  user_id    :integer
#

class EventType < ApplicationRecord
  # Uploader
  mount_uploader :guideline, GuidelineUploader

  # Association
  belongs_to :user
  belongs_to :program
  has_many :events, dependent: :destroy
  has_many :event_type_webhooks
  has_many :webhooks, through: :event_type_webhooks

  # Validation
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:program_id] }
  validates :color, presence: true, uniqueness: { scope: [:program_id] }

  # Callback
  before_validation :set_program_id
  before_validation :set_color
  before_create :set_code

  # Scope
  scope :root, -> { where(default: true).first }
  scope :with_shared, -> (program_id) { where('program_id = ? OR shared = ?', program_id, true) }

  # Deligation
  delegate :name, to: :program, prefix: :program

  # Class methods
  def self.create_root(user_id)
    create(name: 'Unknown', default: true, color: "##{SecureRandom.hex(3)}", user_id: user_id)
  end

  private
    def set_program_id
      self.program_id ||= user.try(:program_id)
    end

    def set_color
      self.color ||= "##{SecureRandom.hex(3)}"
    end

    def set_code
      self.code = name.downcase.split(' ').join('_')
    end
end
