# frozen_string_literal: true

class Notifiers::ReceiveProgramNotificationTelegramNotifier
  attr_reader :user, :notification_receivers, :action

  def initialize(user, action = "connect")
    @user = user
    @notification_receivers = user.program.telegram_notification_receivers.telegrams
    @action = action
  end

  def enabled?
    notification_receivers.length.positive?
  end

  def recipients
    notification_receivers.map(&:telegram_chat_id)
  end

  def display_message
    I18n.t("user.telegram_account_#{action}",
      telegram_username: user.telegram_username,
      phone_number: user.phone_number,
      province: user.location.try(:name_km),
      locale: "km"
    )
  end

  def display_title
  end

  def bot_token
    TelegramBot.system_bot_token
  end
end
