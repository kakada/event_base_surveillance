# frozen_string_literal: true

module EventsHelper
  def option_fields
    test =[1,2]

    arr = Field.roots.map { |field| "<li class='field-code'>#{field[:code]}</li>"}
    dom = '<ul>'

    arr.each do |a|
      dom += a
    end

    dom += '</ul>'
  end

end
