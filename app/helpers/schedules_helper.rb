# frozen_string_literal: true

module SchedulesHelper
  def status_html(enabled)
    return "<span class='text-success'>#{t('shared.active')}</span>" if enabled

    "<span class='text-danger'>#{t('shared.inactive')}</span>"
  end
end
