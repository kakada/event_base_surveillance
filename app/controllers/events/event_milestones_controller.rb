# frozen_string_literal: true

module Events
  class EventMilestonesController < ::ApplicationController
    before_action :assign_event

    def show
      @event_milestone = EventMilestone.find(params[:id])
    end

    def new
      @event_milestone = @event.event_milestones.new(milestone_id: params[:milestone_id])
    end

    def create
      @event_milestone = @event.event_milestones.new(event_milestone_params)

      if @event_milestone.save
        redirect_to event_url(@event)
      else
        render :new
      end
    end

    def edit
      @event_milestone = EventMilestone.find(params[:id])
    end

    def update
      @event_milestone = EventMilestone.find(params[:id])

      if @event_milestone.update_attributes(event_milestone_params)
        redirect_to event_url(@event)
      else
        flash.now[:alert] = @event_milestone.errors.full_messages
        render :edit
      end
    end

    private

    def event_milestone_params
      params.require(:event_milestone).permit(
        :milestone_id,
        field_values_attributes: [
          :id, :field_id, :field_code, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
        ]
      ).merge(
        submitter_id: current_user.id,
        program_id: current_program.id
      )
    end

    def assign_event
      @event = Event.find(params[:event_id])
    end
  end
end
