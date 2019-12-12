# frozen_string_literal: true

module Api
  module V1
    class MilestonesController < ApplicationController
      def index
        milestones = current_program.milestones

        render json: milestones
      end
    end
  end
end
