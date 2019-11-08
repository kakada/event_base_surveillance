# frozen_string_literal: true

module EventsHelper
  def option_fields
    fields = Field.roots.map do |field|
      "<li class='field-code pointer'>#{field[:code]}</li>"
    end

    dom = '<ul class="field-code-wrapper">'

    fields.each do |a|
      dom += a
    end

    dom += '</ul>'
  end
end
