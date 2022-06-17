# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id                       :uuid             not null, primary key
#  channels                 :string           default([]), is an Array
#  date_index               :integer
#  deadline_duration_in_day :integer
#  emails                   :text             default([]), is an Array
#  enabled                  :boolean          default(TRUE)
#  follow_up_hour           :integer
#  interval_type            :integer
#  interval_value           :integer
#  message                  :text
#  name                     :string
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  program_id               :integer
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
  validates :emails, presence: true, if: :summary_schedule?
  validates :deadline_duration_in_day, presence: true, if: :summary_schedule?
  validates :deadline_duration_in_day, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  enum interval_type: {
    day: 1,
    week: 2,
    month: 3
  }

  before_validation :set_type
  before_validation :set_interval_value_and_channel, if: :summary_schedule?

  default_scope { order(updated_at: :desc) }

  # Contant
  TYPES = %w(Schedules::EventSchedule Schedules::SummarySchedule)

  # Instant method
  def reached_time?
    raise "Abstract Method"
  end

  def display_message
    raise "Abstract Method"
  end

  def duration_in_day
    interval_value * duration_in_type
  end

  def summary_schedule?
    type == "Schedules::SummarySchedule"
  end

  def event_schedule?
    type == "Schedules::EventSchedule"
  end

  def duration_in_type
    case interval_type
    when "week"
      7
    when "month"
      30
    else
      1
    end
  end

  # Class method
  def self.types
    TYPES.map { |t| [t.split("::").last, t] }
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

    def set_interval_value_and_channel
      self.interval_value = 1
      self.channels = ["email"]
    end
end
