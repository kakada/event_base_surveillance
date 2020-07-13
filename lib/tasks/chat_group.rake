# frozen_string_literal: true

namespace :chat_group do
  desc 'migrate super chat group'
  task migrate_supergroup: :environment do
    ChatGroup.where(chat_type: ChatGroup::TELEGRAM_SUPER_GROUP).each do |supergroup|
      if chat_group = ChatGroup.where(title: supergroup.title, chat_type: ChatGroup::TELEGRAM_GROUP).first.presence
        chat_group.update(chat_id: supergroup.chat_id, chat_type: supergroup.chat_type)
        supergroup.destroy
      end
    end
  end
end
