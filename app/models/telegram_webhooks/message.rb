# frozen_string_literal: true

module TelegramWebhooks
  class Message < Base
    def process
      return update_to_super_group if message["migrate_to_chat_id"].present?

      upsert_chat_group if member_request?
    end

    private
      def update_to_super_group
        group = ChatGroup.find_by(chat_id: chat["id"].to_s)
        return unless group.present?

        group.update(chat_id: message["migrate_to_chat_id"], chat_type: ChatGroup::TELEGRAM_SUPER_GROUP)
      end

      def upsert_chat_group
        return unless program.present?

        group = program.chat_groups.find_or_initialize_by(chat_id: chat["id"].to_s, provider: "Telegram")
        group.update_attributes(chat_group_params)
      end

      def chat_group_params
        {
          title: chat["title"],
          is_active: message["new_chat_member"].present?,
          chat_type: chat["type"]
        }
      end

      def program
        @program ||= ::TelegramBot.where("token LIKE ?", "#{member['id']}%").first.try(:program)
      end

      # {"id"=>123, "is_bot"=>true, "first_name"=>"ebs_bot", "username"=>"ebs_system_bot"}
      def member
        @member ||= message["left_chat_member"] || message["new_chat_member"]
      end

      # "chat"=>{"id"=>-369435878, "title"=>"ebs-group-chat", "type"=>"group", "all_members_are_administrators"=>true}
      def member_request?
        member.present? && member["is_bot"] && ChatGroup::TELEGRAM_CHAT_TYPES.include?(chat["type"])
      end
  end
end
