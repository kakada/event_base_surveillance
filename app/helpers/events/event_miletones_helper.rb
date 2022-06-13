# frozen_string_literal: true

module Events
  module EventMiletonesHelper
    def description_html(description)
      strip_tags(description).gsub('\n', "<br />").html_safe
    end
  end
end
