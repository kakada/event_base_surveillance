# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  before_action :set_locale

  def message(message)
    if group = message["migrate_to_chat_id"].present? && ChatGroup.find_by(chat_id: message["chat"]["id"].to_s).presence
      return group.update(chat_id: message["migrate_to_chat_id"], chat_type: ChatGroup::TELEGRAM_SUPER_GROUP)
    end

    # {"id"=>952424355, "is_bot"=>true, "first_name"=>"ebs_bot", "username"=>"ebs_system_bot"}
    member = message["left_chat_member"] || message["new_chat_member"]
    return unless member.present? && member["is_bot"]

    # "chat"=>{"id"=>-369435878, "title"=>"ebs-group-chat", "type"=>"group", "all_members_are_administrators"=>true}
    chat = message["chat"]
    return unless ChatGroup::TELEGRAM_CHAT_TYPES.include?(chat["type"])

    if program = TelegramBot.where("token LIKE ?", "#{member['id']}%").first.try(:program).presence
      group = program.chat_groups.find_or_initialize_by(chat_id: chat["id"].to_s, provider: "Telegram")
      group.update_attributes(title: chat["title"], is_active: message["new_chat_member"].present?, chat_type: chat["type"])
    end
  end

  # First start with bot
  def start!(word = nil, *other_words)
    sms = I18n.t("telegram_bot.welcome_message", username: chat["first_name"])

    send_message(chat["id"], sms)
  end

  # /connect 011222333 120101
  # /connect 011222333 place_name
  # /connect phone_number_or_email province_name_or_code
  def connect!(phone_or_email = nil, *province_name_or_code)
    user = User.from_telegram(phone_or_email, province_name_or_code.join(" "))
    sms = I18n.t("telegram_bot.invalid_info_message", command: "connect", username: chat["first_name"])

    if user.present?
      user.update(telegram_chat_id: chat["id"], telegram_username: chat["first_name"])
      sms = I18n.t("telegram_bot.congratulation_message", username: chat["first_name"], location: user.location.name_km)
    end

    send_message(chat["id"], sms)
  end

  # /disconnect 011222333 120101
  # /disconnect 011222333 place_name
  # /disconnect phone_number_or_email province_name_or_code
  def disconnect!(phone_or_email = nil, *province_name_or_code)
    user = User.from_telegram(phone_or_email, province_name_or_code.join(" "))
    sms = I18n.t("telegram_bot.invalid_info_message", command: "disconnect", username: chat["first_name"])

    if user.present?
      user.update(telegram_chat_id: nil, telegram_username: nil)
      sms = I18n.t("telegram_bot.disconnect_message", username: chat["first_name"], location: user.location.name_km)
    end

    send_message(chat["id"], sms)
  end

  private
    def send_message(chat_id, sms)
      ::TelegramBot.send_message(chat_id, sms)
    end

    def set_locale
      I18n.locale = :km
    end
end
