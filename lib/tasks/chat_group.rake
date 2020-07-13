# frozen_string_literal: true

namespace :chat_group do
  desc 'migrate super chat group'
  task migrate_supergroup: :environment do
    ChatGroup.where(chat_type: ChatGroup::TELEGRAM_SUPER_GROUP).each do |supergroup|
      migrate_chat_group(supergroup)
    end
  end

  private

  def migrate_chat_group(supergroup)
    chat_group = ChatGroup.where(title: supergroup.title, chat_type: ChatGroup::TELEGRAM_GROUP).first
    return if chat_group.nil?

    chat_group.update(chat_id: supergroup.chat_id, chat_type: supergroup.chat_type)
    supergroup.destroy
  end
end
