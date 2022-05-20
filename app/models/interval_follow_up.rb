# frozen_string_literal: true

# == Schema Information
#
# Table name: interval_follow_ups
#
#  id               :bigint           not null, primary key
#  channels         :string           default([]), is an Array
#  duration_in_day  :integer
#  duration_in_hour :integer
#  enabled          :boolean
#  message          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  program_id       :integer
#

class IntervalFollowUp < ApplicationRecord
  # Association
  belongs_to :program

  # Validation
  validates :duration_in_day, presence: true, if: :enabled?
  validates :duration_in_day, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :duration_in_hour, presence: true, if: :enabled?
  validates :duration_in_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }, allow_nil: true
  validate  :correct_channels

  after_initialize :set_message

  CHANNELS = %w(email telegram)

  private
    def set_message
      self.message = 'Your created event code {{event.uuid}} has been keep a part for a while. Your last update step on the event is {{event.progress}}. Would you consider update it to next step?'
    end

    def correct_channels
      channels.reject!(&:blank?)

      errors.add(:channels, "Channels can't be blank") if channels.blank?
      errors.add(:channels, "Channels is invalid") if channels.detect { |s| !(CHANNELS.include? s) }
    end
end
