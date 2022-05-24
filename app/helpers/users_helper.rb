# frozen_string_literal: true

module UsersHelper
  def telegram_icon_status(user)
    return "" unless user.telegram?

    title = t('telegram_bot.already_associated', username: user.telegram_username)
    str = "<span class='p-1 pointer text-primary' data-trigger='hover' title='#{title}' data-toggle='tooltip'>"
    str += "<i class='fab fa-telegram telegram-icon' aria-hidden='true'></i>"
    str + "</span>"
  end
end
