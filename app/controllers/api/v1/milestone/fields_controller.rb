# frozen_string_literal: true

module Api
  module V1
    module Milestone
      class FieldsController < ::Api::V1::ApplicationController
        def index
          milestone = ::Milestone.find(params[:milestone_id])

          render json: milestone.fields, meta: { milestone: milestone, extra_fields: milestone.extra_fields }, adapter: :json, root: 'fields'
        end
      end
    end
  end
end
