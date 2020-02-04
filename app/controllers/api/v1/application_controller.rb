# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ActionController::Base
      include Pagy::Backend

      skip_before_action :verify_authenticity_token

      before_action :restrict_access

      def current_program
        @current_program ||= current_client_app.program
      end
      helper_method :current_program

      attr_reader :current_client_app
      helper_method :current_client_app

      private
        def restrict_access
          authenticate_or_request_with_http_token do |token, _options|
            @current_client_app = ClientApp.find_by(access_token: token, ip_address: request.remote_ip)
            # @current_client_app = ClientApp.find_by(access_token: token)
            @current_client_app.present? && @current_client_app.authorize?(request.method)
          end
        end
    end
  end
end
