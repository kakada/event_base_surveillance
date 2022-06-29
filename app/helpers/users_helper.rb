# frozen_string_literal: true

module UsersHelper
  def telegram_icon(user)
    return "" unless user.telegram?

    title = t("telegram_bot.already_associated", username: user.telegram_username)
    str = "<span class='p-1 pointer icon-telegram' data-trigger='hover' title='#{title}' data-toggle='tooltip'>"
    str += "<i class='fab fa-telegram telegram-icon' aria-hidden='true'></i>"
    str + "</span>"
  end

  def telegram_account_status(user)
    return telegram_icon(user) if current_user.telegram?

    "<span class='text-gray-600 p-1' data-toggle='tooltip' title='#{t('user.telegram_account_is_not_connected')}'>#{icon_telegram}</span>"
  end
end
