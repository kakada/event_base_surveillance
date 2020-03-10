# frozen_string_literal: true

module EventsHelper
  def option_fields
    fields = [{ code: 'suspected_event' }].concat(Field.roots).map do |field|
      "<li class='field-code pointer'>#{field[:code]}</li>"
    end

    dom = '<ul class="field-code-wrapper">'

    fields.each do |a|
      dom += a
    end

    dom += '</ul>'
  end

  def filter_date_options
    [
      { label: 'Days ago', value: 'Day' },
      { label: 'Weeks ago', value: 'Week' },
      { label: 'Months ago', value: 'Month' },
      { label: 'Years ago', value: 'Year' }
    ]
  end

  def filter_date_popover
    dom = render('events/filter_date_popover_content')
    content_tag(:div, '', class: 'hidden filter-date', data: { html: dom.gsub("\n", '') })
  end

  def skip_logic_data(field)
    return unless field.relevant.present?
    code, operator, value = field.relevant.split('||')
    { code: field_code(code), operator: operator, value: value.downcase } if field.present?
  end

  def field_code(code)
    code.gsub(/[^0-9_A-Za-z]/, '')
  end

  def form_field_class(field, error_msg)
    css_class = []
    css_class << (error_msg.present? ? 'form-group form-group-invalid' : 'form-group')
    css_class << 'hidden' if field.relevant.present?
    css_class.join(' ')
  end

  def shared_event?(user, event)
    !user.system_admin? && event.event_type_shared? && event.program_id != user.program_id
  end
end
