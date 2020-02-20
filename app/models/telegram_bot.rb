class TelegramBot < ApplicationRecord
  belongs_to :program

  validates :token, :username, presence: true, :if => :enabled?

  before_create :post_webhook_to_telegram
  before_update :post_webhook_to_telegram

  def post_webhook_to_telegram
    request = RestClient::Request.new( method: :post, url: "https://api.telegram.org/bot#{token}/setWebhook?url=#{ENV['TELEGRAM_CALLBACK_URL']}")
    response = request.execute {|response| response}
    self.actived = (response.code == 200)
  end
end
