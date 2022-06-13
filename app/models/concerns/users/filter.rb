# frozen_string_literal: true

module Users
  module Filter
    extend ActiveSupport::Concern

    included do
      # class methods
      class << self
        def filter(params)
          scope = all
          scope = scope.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
          scope
        end

        def from_telegram(phone_or_email, province)
          return nil if phone_or_email.blank? || province.blank?

          scope = where("phone_number = ? OR email = ?", phone_or_email, phone_or_email)
          scope = scope.where(location: "all") if national?(province)
          scope = scope.joins(:location).where("locations.code = ? OR locations.name_en = ? OR locations.name_km = ?", province, province, province) unless national?(province)
          scope.first
        end

        def from_omniauth(access_token)
          data = access_token.info
          user = User.where(email: data["email"]).first
          user
        end

        private
          def national?(keyword)
            ["national", "ថ្នាក់ជាតិ", "គ្រប់ខេត្ត", "គ្រប់ខេត្ត/ក្រុង"].include?(keyword.downcase)
          end
      end
    end
  end
end
