# frozen_string_literal: true

module Api
  module V1
    class EventMilestonesController < ApplicationController
      def create
        @event_milestone = EventMilestone.new(event_milestone_params)

        if @event_milestone.save
          render json: @event_milestone
        else
          render json: { error: @event_milestone.errors }, status: :unprocessable_entity
        end
      end

      def update
        @event_milestone = EventMilestone.find(params[:id])

        if @event_milestone.update_attributes(event_milestone_params)
          render json: @event_milestone
        else
          render json: { error: @event_milestone.errors }, status: :unprocessable_entity
        end
      end

      private
        def event_milestone_params
          params.require(:event_milestone).permit(
            :milestone_id,
            :event_uuid,
            field_values_attributes: [
              :id, :field_id, :field_code, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
            ]
          ).merge(
            program_id: current_program.id
          )
        end
    end
  end
end
