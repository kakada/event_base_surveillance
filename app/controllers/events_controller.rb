# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event_type, only: %i[new create edit update]

  def index
    @pagy, @events = pagy(policy_scope(Event.filter(params).order_desc.includes(:field_values, :event_type, :creator, :program)))
  end

  def show
    @event = authorize Event.find(params[:id])
  end

  def new
    @event = authorize current_program.events.new(event_type_id: params[:event_type_id])
  end

  def create
    @event = authorize current_user.events.new(event_params)

    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    @event = authorize Event.find(params[:id])
  end

  def update
    @event = authorize Event.find(params[:id])

    if @event.update_attributes(event_params)
      redirect_to @event
    else
      flash.now[:alert] = @event.errors.full_messages
      render :edit
    end
  end

  def download
    events = policy_scope(Event.filter(params).includes(:field_values, :event_milestones))

    if events.length > ENV['MAXIMUM_DOWNLOAD_RECORDS'].to_i
      flash[:alert] = t('event.file_size_is_too_big')
      redirect_to events_url
    else
      send_data(EventService.new(events, current_program, params[:template_id]).export_csv, filename: 'events.csv')
    end
  end

  def search
    @pagy, @events = pagy(policy_scope(Event.filter(params)), link_extra: 'data-remote="true"')
  end

  private
    def event_params
      params.require(:event).permit(
        :event_type_id, :link_uuid,
        properties: {},
        field_values_attributes: [
          :id, :field_id, :field_code, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
        ]
      )
    end

    def set_event_type
      @event_types = policy_scope(EventType.all)
    end
end
