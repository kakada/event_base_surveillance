# frozen_string_literal: true

class TelegramBot < ApplicationRecord
  belongs_to :program

  validates :token, :username, presence: true, if: :enabled?

  before_create :post_webhook_to_telegram
  before_update :post_webhook_to_telegram

  def post_webhook_to_telegram
    bot = Telegram::Bot::Client.new(token: token, username: username)

    begin
      request = bot.set_webhook(url: ENV['TELEGRAM_CALLBACK_URL'])
      self.actived = request["ok"]
    rescue
      self.actived = false
    end
  end
end
