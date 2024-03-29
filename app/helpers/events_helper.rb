# frozen_string_literal: true

module EventsHelper
  def option_fields
    fields = [{ code: "id" }, { code: "suspected_event" }].concat(Field.roots).map do |field|
      "<li class='field-code pointer'>#{field[:code]}</li>"
    end

    dom = '<ul class="field-code-wrapper">'

    fields.each do |a|
      dom += a
    end

    dom += "</ul>"
  end

  def filter_date_options
    [
      { label: "Days ago", value: "Day" },
      { label: "Weeks ago", value: "Week" },
      { label: "Months ago", value: "Month" },
      { label: "Years ago", value: "Year" }
    ]
  end

  def filter_date_popover
    dom = render("events/index/filter_date_popover_content")
    content_tag(:div, "", class: "hidden filter-date", data: { html: dom.gsub("\n", "") })
  end

  def skip_logic_data(field)
    return unless field.relevant.present?
    code, operator, value = field.relevant.split("||")
    { code: field_code(code), operator: operator, value: value.downcase } if field.present?
  end

  def field_code(code)
    code.gsub(/[^0-9_A-Za-z]/, "")
  end

  def form_field_class(field, error_msg)
    css_class = []
    css_class << (error_msg.present? ? "form-group form-group-invalid" : "form-group")
    css_class << "hidden" if field.relevant.present?
    css_class.join(" ")
  end

  def shared_in?(user, event)
    !user.system_admin? && event.shared_with?(user.program_id)
  end

  def shared_out?(user, event)
    !user.system_admin? && event.shared_out?(user.program_id)
  end

  def no_value(field)
    return "-" unless %w(Fields::SelectOneField Fields::SelectMultipleField).include? field.field_type

    "<span data-relevant='#{field_code(field.code)}'>-</span>"
  end

  def creator_info_tooltip(user)
    return "" unless user.present?

    title = '<div class="text-left">'
    title += "<div>#{t('user.name')}: #{user.full_name}</div>"
    title += "<div>#{t('user.email')}: #{user.email} (#{user.location_name})</div>"
    title += "<div>#{t('user.phone_number')}: #{user.phone_number}</div>" if user.phone_number.present?
    title += "</div>"

    "<span data-title='#{title}' data-toggle='tooltip' data-html='true'>#{user.full_name}</span>"
  end

  def conducted_at_html(em, milestone)
    milestone.fields.milestone_datetimes.map do |field|
      fv = em.get_value_by_code(field.code)
      fv.present? ? "<small>#{fv.html_tag}</small> <small class='text-muted'>(#{field.name})</small>" : ""
    end.join("")
  end

  def icon_telegram
    '<i class="fab fa-telegram icon-telegram"></i>'
  end

  def icon_email
    '<i class="fas fa-envelope icon-email"></i>'
  end

  def telegram_tooltip(creator)
    return "" if creator.telegram?
    return t("event.no_system_bot_configure") unless TelegramBot.has_system_bot?

    t("event.event_creator_no_telegram_account")
  end

  def letter_badge(color, letter)
    "<div class='small-color' style='border-color:#{color}; color: #{color}'>#{letter}</div>"
  end

  def creator_info(event)
    return "#{t('event.creator')}: has been removed!" if event.creator.nil?

    "#{t('event.creator')}: #{event.creator_email} (#{event.creator.location_name})"
  end
end
