# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  strip_attributes

  def self.update_order!(ids)
    return if ids.blank?

    ids.each_with_index do |id, index|
      where(id: id).update_all(display_order: index + 1)
    end
  end
end
