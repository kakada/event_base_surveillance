# frozen_string_literal: true

module Api
  module V1
    module Events
      class FormsController < ApplicationController
        before_action :assign_event

        def index
          @pagy, @forms = pagy(@event.forms)

          render json: @forms, adapter: :json, meta: @pagy
        end

        def show
          @form = @event.forms.find(params[:id])

          render json: @form
        end

        def create
          @form = @event.forms.new(form_params)

          if @form.save
            render json: @form
          else
            render json: { error: @form.errors }, status: :unauthorized
          end
        end

        def update
          @form = Form.find(params[:id])

          if @form.update_attributes(form_params)
            render json: @form
          else
            render json: { error: @form.errors }, status: :unauthorized
          end
        end

        private

        def form_params
          params.require(:form).permit(
            :submitter_id, :form_type_id, :conducted_at,
            field_values_attributes: [
              :id, :field_id, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
            ]
          ).merge(source: current_client_app.name)
        end

        def assign_event
          @event = current_program.events.find(params[:event_id])
        end
      end
    end
  end
end
