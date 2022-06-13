# frozen_string_literal: true

module Events
  module Valueable
    extend ActiveSupport::Concern

    included do
      include Events::FieldValueValidation
      include Events::TraceableField

      has_many   :field_values, as: :valueable, dependent: :destroy
      has_many   :tracings, as: :traceable, dependent: :destroy

      def get_value_by_code(field_code)
        field_values.find_by(field_code: field_code)
      end
    end
  end
end
