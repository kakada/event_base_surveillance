# frozen_string_literal: true

module Api
  module V1
    class EventTypesController < ApplicationController
      def index
        @pagy, @event_types = pagy(current_program.event_types)

        render json: @event_types, adapter: :json, meta: @pagy
      end
    end
  end
end
