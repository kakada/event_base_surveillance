# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event_type, only: %i[new create edit update]

  def index
    @pagy, @events = pagy(policy_scope(Event.includes(:event_milestones).includes(creator: :program)))
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
      EventWorker.perform_async(@event.uuid)
      redirect_to @event
    else
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

  def download
    send_file "#{Rails.root}/public/#{params[:file]}", disposition: 'attachment'
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

  def set_event_type
    @event_types = policy_scope(EventType.all)
  end
end
