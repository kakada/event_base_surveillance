# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ActionController::Base
      include Pagy::Backend
      before_action :restrict_access

      def current_program
        @current_program ||= @current_api_key.program
      end
      helper_method :current_program

      def current_api_key
        @current_api_key
      end
      helper_method :current_api_key

      private

      def restrict_access
        authenticate_or_request_with_http_token do |token, _options|
          # @current_api_key = ApiKey.find_by(access_token: token, ip_address: request.remote_ip).presence
          @current_api_key = ApiKey.find_by(access_token: token).presence
        end
      end
    end
  end
end
