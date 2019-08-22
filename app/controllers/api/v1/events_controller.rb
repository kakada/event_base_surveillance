# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def index
        @pagy, @events = pagy(current_program.events)

        render json: @events, adapter: :json, meta: @pagy
      end

      def show
        @event = current_program.events.find(params[:id])
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

      def destroy
        @event = current_program.events.find(params[:id])
        @event.destroy

        head :no_content
      end

      private

      def event_params
        params.require(:event).permit(
          :name, :event_type_id, :value, :description, :event_date, :report_date,
          :location, :province_id, :district_id, :commune_id, :village_id,
          properties: {},
          field_values_attributes: [
            :id, :field_id, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
          ]
        ).merge(source: current_api_key.name)
      end
    end
  end
end
