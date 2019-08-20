# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::Base
      before_action :restrict_access

      private

      def restrict_access
        authenticate_or_request_with_http_token do |token, _options|
          # ApiKey.exists?(access_token: token, ip_address: request.remote_ip)
          ApiKey.exists?(access_token: token)
        end
      end
    end
  end
end
