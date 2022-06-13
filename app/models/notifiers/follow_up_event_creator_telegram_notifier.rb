# frozen_string_literal: true

class Notifiers::FollowUpEventCreatorTelegramNotifier
  attr_reader :follow_up

  def initialize(follow_up)
    @follow_up = follow_up
  end

  def enabled?
    follow_up.channels.include?("telegram") &&
    follow_up.followee.telegram?
  end

  def recipients
    [follow_up.followee.telegram_chat_id]
  end

  def display_message
    follow_up.message
  end

  def display_title
  end

  def bot_token
    TelegramBot.system_bot_token
  end
end
