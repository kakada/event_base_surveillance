# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  enable_telegram           :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  creator_id                :integer
#  language_code             :string
#  enable_email_notification :boolean          default(FALSE)
#

class Program < ApplicationRecord
  include Programs::ElasticsearchConcern

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
  has_one   :telegram_bot, :dependent => :destroy

  validates :name, presence: true

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
