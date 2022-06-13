# frozen_string_literal: true

module Events
  module Location
    extend ActiveSupport::Concern

    included do
      before_validation :assign_nil_locations
      before_validation :set_location_code

      def location_name(address = "address_km")
        return if location_code.blank?

        "Pumi::#{::Location.location_kind(location_code).titlecase}".constantize.find_by_id(location_code).try("#{address}".to_sym)
      end

      private
        def assign_nil_locations
          fvs = %w[province_id district_id commune_id village_id].map do |code|
            field_values.select { |fv| fv.field_code == code }.first
          end

          clear_next = false
          fvs.each do |fv|
            next if fv.nil?

            fv.value = nil if clear_next == true
            clear_next = fv.value.blank?
          end
        end

        def set_location_code
          codes = %w[province_id district_id commune_id village_id].map do |code|
            field_values.select { |fv| fv.field_code == code }.first.try(:value).to_s
          end

          self.location_code = codes[codes.find_index("").to_i - 1]
        end
    end
  end
end
