# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def message(message)
    chat = message['chat']
    return unless chat['type'] == 'group'

    group = ChatGroup.find_or_initialize_by(chat_id: chat['id'], provider: 'Telegram')
    group.update_attributes(title: chat['title'], is_active: true)
  end
end
