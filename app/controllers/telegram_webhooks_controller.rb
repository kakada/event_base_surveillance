class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: t('.content')
  end

  def message(message)
    # byebug
    # message can be also accessed via instance method
    # {"id"=>-366633200, "title"=>"EBS_Group", "type"=>"group", "all_members_are_administrators"=>true}


    chat = message['chat']
    return unless chat['type'] == 'group'
    group = TelegramGroup.find_or_initialize_by(chat_id: chat['id'])
    group.update_attributes(title: chat['title'])


    # left_chat_member = message['left_chat_member']

    # return if left_chat_member.nil? || left_chat_member['is_bot'] == false
    # return unless left_chat_member['username'] == 'ebs_system_bot'
    # group.update_attributes(is_active: false, reason: 'left group')

    # new_chat_member = message['new_chat_member']
    # return if new_chat_member.nil? || new_chat_member['is_bot'] == false
    # return unless new_chat_member['username'] == 'ebs_system_bot'
    # group.update_attributes(is_active: true, reason: nil)
  end
end
