# frozen_string_literal: true

module Api
  module V1
    class EventTypesController < ApplicationController
      def index
        @pagy, @event_types = pagy(current_program.event_types)

        render json: @event_types, adapter: :json, meta: @pagy
      end

      def create
        @event_type = current_program.event_types.new(event_type_params)

        if @event_type.save
          render json: @event_type
        else
          render json: { error: @event_type.errors }, status: :unauthorized
        end
      end

      def update
        @event_type = current_program.event_types.find(params[:id])

        if @event_type.update_attributes(event_type_params)
          render json: @event_type
        else
          render json: { error: @event_type.errors }, status: :unauthorized
        end
      end

      def destroy
        @event_type = current_program.event_types.find(params[:id])
        @event_type.destroy

        head :no_content
      end

      private

      def event_type_params
        params.require(:event_type).permit(
          :name, :color,
          fields_attributes: [
            :id, :name, :field_type, :required, :display_order,
            :mapping_field, :mapping_field_type, :_destroy,
            field_options_attributes: %i[
              id name value color _destroy
            ]
          ]
        )
      end
    end
  end
end
