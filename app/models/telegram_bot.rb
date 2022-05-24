# frozen_string_literal: true

# == Schema Information
#
# Table name: telegram_bots
#
#  id         :bigint           not null, primary key
#  actived    :boolean          default(FALSE)
#  enabled    :boolean          default(FALSE)
#  token      :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :integer
#

class TelegramBot < ApplicationRecord
  belongs_to :program

  validates :token, :username, presence: true, if: :enabled?

  before_create :post_webhook_to_telegram
  before_update :post_webhook_to_telegram

  def post_webhook_to_telegram
    bot = Telegram::Bot::Client.new(token: token, username: username)

    begin
      request = bot.set_webhook(url: ENV['TELEGRAM_CALLBACK_URL'])
      self.actived = request['ok']
    rescue
      self.actived = false
    end
  end

  def self.send_message(chat_id, message)
    ::Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'], ENV['TELEGRAM_USERNAME'])
                           .send_message(chat_id: chat_id, text: message, parse_mode: :HTML)
  end

  def self.has_system_bot?
    ENV['TELEGRAM_TOKEN'].present? && ENV['TELEGRAM_USERNAME'].present?
  end
end
