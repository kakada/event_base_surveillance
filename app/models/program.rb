# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                        :bigint           not null, primary key
#  enable_email_notification :boolean          default(FALSE)
#  language_code             :string
#  name                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  creator_id                :integer
#

class Program < ApplicationRecord
  include Programs::ElasticsearchConcern

  mount_uploader :logo, LogoUploader

  belongs_to :creator, class_name: 'User'
  LANGUAGES = [
    %w[English en],
    %w[ខ្មែរ km]
  ].freeze

  has_many  :users
  has_many  :client_apps
  has_many  :events
  has_many  :event_types
  has_many  :milestones
  has_many  :webhooks
  has_many  :chat_groups
  has_one   :telegram_bot, dependent: :destroy
  has_many  :templates

  validates :name, presence: true
  validates :unlock_event_duration, numericality: { greater_than_or_equal_to: 1,  only_integer: true }

  before_create :set_default_language
  after_create :create_root_milestone
  after_create :create_unknown_event_type
  after_create { ProgramWorker.perform_async(id) }

  accepts_nested_attributes_for :telegram_bot, allow_destroy: true

  delegate :enabled, to: :telegram_bot, prefix: :telegram_bot, allow_nil: true

  def format_name
    name.downcase.split(' ').join('_')
  end

  def enable_telegram?
    self.telegram_bot_enabled
  end

  def logo_or_default
    logo_url || 'default_logo.png'
  end

  private
    def set_default_language
      self.language_code ||= 'en'
    end

    def create_root_milestone
      milestones.create_root(creator_id)
    end

    def create_unknown_event_type
      event_types.create_root(creator_id)
    end
end
