# frozen_string_literal: true

class Notifiers::AccountOwnerTelegramNotifier
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def enabled?
    user.telegram?
  end

  def recipients
    [user.telegram_chat_id]
  end

  def display_message
    I18n.t("user.your_telegram_account_disconnected",
      phone_number: user.phone_number,
      province: user.location.try(:name_km),
      locale: 'km'
    )
  end

  def display_title
  end

  def bot_token
    TelegramBot.system_bot_token
  end
end
