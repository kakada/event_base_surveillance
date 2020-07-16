# frozen_string_literal: true

module MilestonesHelper
  def telegram_icon_status(milestone)
    return '' unless milestone.message.present?

    if milestone.program.telegram_bot.nil? || !milestone.program.telegram_bot.actived?
      return '<a class="btn btn-small text-danger" title="Telegram bot is invalid configure" data-toggle="tooltip"><i class="fab fa-telegram"></i></a>'
    elsif !milestone.program.telegram_bot.enabled? || milestone.telegram_notification.nil? || milestone.telegram_notification.chat_groups.blank?
      return '<a class="btn btn-small text-secondary" title="Telegram bot is disabled or no chat groups selected" data-toggle="tooltip"><i class="fab fa-telegram"></i></a>'
    else
      return "<a class='btn btn-small text-success' data-trigger='hover' data-content='#{milestone.telegram_notification.chat_groups.pluck(:title).join('; ')}' data-toggle='popover' title='Telegram Chat Group'><i class='fab fa-telegram'></i></a>"
    end
  end

  def email_icon_status(milestone)
    return '' unless milestone.message.present?

    if !milestone.program.enable_email_notification? || milestone.email_notification.nil? || milestone.email_notification.emails.blank?
      return '<a class="btn btn-small text-secondary" title="Email is disabled or no emails selected" data-toggle="tooltip"><i class="far fa-envelope"></i></a>'
    else
      return "<a class='btn btn-small text-success' data-trigger='hover' data-content='#{milestone.email_notification.emails.join('; ')}' data-toggle='popover' title='Email group'><i class='fas fa-envelope'></i></a>"
    end
  end
end
