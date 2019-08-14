# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @event_types = policy_scope(EventType.includes(:form_types))
    @events = policy_scope(Event.includes(:forms).includes(creator: :program))
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(event_type_id: params[:event_type_id])
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to @event
    else
      flash.now[:alert] = @event.errors.full_messages
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(event_params)
      redirect_to @event
    else
      flash.now[:alert] = @event.errors.full_messages
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_url
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :event_type_id, :value, :description, :event_date, :report_date, :location, :geo_point,
      properties: {},
      field_values_attributes: [
        :id, :field_id, :value, { values: [] }, :image, :image_cache, :_destroy, properties: {}
      ]
    )
  end
end
