class TelegramNotification < ApplicationRecord
  belongs_to :milestone
  before_validation :cleanup_chat_ids

  private

  def cleanup_chat_ids
    return if chat_ids.blank?

    self.chat_ids = chat_ids.reject(&:blank?)
  end
end
