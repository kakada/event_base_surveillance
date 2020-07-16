# frozen_string_literal: true

module MilestonesHelper
  def telegram_icon_status(milestone)
    return '' unless milestone.message.present?

    if milestone.program.telegram_bot.nil? || !milestone.program.telegram_bot.actived?
      return '<a class="btn btn-small text-secondary position-relative" title="Telegram bot is invalid configure" data-toggle="tooltip"><i class="fab fa-telegram font-size-24"></i><i class="far fa-times-circle icon-red invalid-config-icon"></i></a>'
    elsif !milestone.program.telegram_bot.enabled? || milestone.telegram_notification.nil? || milestone.telegram_notification.chat_groups.blank?
      return '<a class="btn btn-small text-secondary" title="Telegram bot is disabled or no group notification selected" data-toggle="tooltip"><i class="fab fa-telegram font-size-24"></i></a>'
    end

    "<a class='btn btn-small text-success' data-trigger='hover' data-content='#{milestone.telegram_notification.chat_groups.pluck(:title).join('; ')}' data-toggle='popover' title='Notify to'><i class='fab fa-telegram font-size-24 active-telegram-icon'></i></a>"
  end

  def email_icon_status(milestone)
    return '' unless milestone.message.present?

    if !milestone.program.enable_email_notification? || milestone.email_notification.nil? || milestone.email_notification.emails.blank?
      return '<a class="btn btn-small text-secondary" title="Email is disabled or no email notification selected" data-toggle="tooltip"><i class="far fa-envelope font-size-24"></i></a>'
    end

    "<a class='btn btn-small text-danger' data-trigger='hover' data-content='#{milestone.email_notification.emails.join('; ')}' data-toggle='popover' title='Notify to'><i class='far fa-envelope font-size-24'></i></a>"
  end
end
