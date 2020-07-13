# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def message(message)
    if group = message['migrate_to_chat_id'].present? && ChatGroup.find_by(chat_id: message['chat']['id'].to_s).presence
      return group.update(chat_id: message['migrate_to_chat_id'], chat_type: 'supergroup')
    end

    # {"id"=>952424355, "is_bot"=>true, "first_name"=>"ebs_bot", "username"=>"ebs_system_bot"}
    member = message['left_chat_member'] || message['new_chat_member']
    return unless member.present? && member['is_bot']

    # "chat"=>{"id"=>-369435878, "title"=>"ebs-group-chat", "type"=>"group", "all_members_are_administrators"=>true}
    chat = message['chat']
    return unless (chat['type'] == 'group' || chat['type'] == 'supergroup')

    if program = TelegramBot.where('token LIKE ?', "#{member['id']}%").first.try(:program).presence
      group = program.chat_groups.find_or_initialize_by(chat_id: chat['id'].to_s, provider: 'Telegram')
      group.update_attributes(title: chat['title'], is_active: message['new_chat_member'].present?, chat_type: chat['type'])
    end
  end
end
