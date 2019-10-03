# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def index
        @pagy, @events = pagy(current_program.events.includes(:field_values))

        render json: @events, adapter: :json, meta: @pagy
      end

      def show
        @event = current_program.events.find(params[:id])

        render json: @event
      end

      def create
        @event = current_program.events.new(event_params)

        if @event.save
          render json: @event
        else
          render json: { error: @event.errors }, status: :unauthorized
        end
      end

      def update
        @event = current_program.events.find(params[:id])

        if @event.update_attributes(event_params)
          render json: @event
        else
          render json: { error: @event.errors }, status: :unauthorized
        end
      end

      private

      def event_params
        params.require(:event).permit(
          :event_type_id, properties: {},
          field_values_attributes: [
            :id, :field_id, :field_code, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
          ]
        )
      end
    end
  end
end
