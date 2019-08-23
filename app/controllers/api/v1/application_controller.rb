# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ActionController::Base
      include Pagy::Backend

      skip_before_action :verify_authenticity_token

      before_action :restrict_access

      def current_program
        @current_program ||= current_api_key.program
      end
      helper_method :current_program

      attr_reader :current_api_key
      helper_method :current_api_key

      private

      def restrict_access
        authenticate_or_request_with_http_token do |token, _options|
          @current_api_key = ApiKey.find_by(access_token: token, ip_address: request.remote_ip)
          # @current_api_key = ApiKey.find_by(access_token: token)

          if @current_api_key.nil? || !@current_api_key.active?
            false
          elsif request.method == 'GET'
            @current_api_key.permissions.include?('read')
          else
            @current_api_key.permissions.include?('write')
          end
        end
      end
    end
  end
end
