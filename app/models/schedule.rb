# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id             :uuid             not null, primary key
#  channels       :string           default([]), is an Array
#  date_index     :integer
#  emails         :text
#  enabled        :boolean          default(TRUE)
#  follow_up_hour :integer
#  interval_type  :integer
#  interval_value :integer
#  message        :text
#  name           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  program_id     :integer
#

class Schedule < ApplicationRecord
  include FollowUps::Channel

  # Association
  belongs_to :program

  # Validation
  validates :name, presence: true
  validates :type, presence: true
  validates :message, presence: true
  validates :interval_type, presence: true
  validates :interval_value, presence: true
  validates :follow_up_hour, presence: true
  validates :follow_up_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }, allow_nil: true

  enum interval_type: {
    day: 1,
    week: 2,
    month: 3
  }

  before_validation :set_type

  # Contant
  TYPES = %w(Schedules::EventSchedule)

  # Instant method
  def reached_hour?
    follow_up_hour == Time.zone.now.hour
  end

  def duration_in_day
    interval_value * duration_in_type
  end

  def template_fields
    ::Templates::EventScheduleField.all
  end

  def duration_in_type
    case interval_type
    when 'week'
      7
    when 'month'
      30
    else
      1
    end
  end

  # Class method
  def self.types
    TYPES.map { |t| [t.split('::').last, t] }
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Schedule.model_name
      end
    end
    super
  end

  private
    def set_type
      self.type ||= "Schedules::EventSchedule"
    end
end
