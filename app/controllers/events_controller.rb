class EventsController < ApplicationController
  def index
    @event_types = policy_scope(EventType.includes(:form_types))
    @events = Event.includes(:forms)
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
      redirect_to events_url
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
      redirect_to events_url
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
      :name, :event_type_id, :value, :description, :location, :geo_point, properties: {},
      field_values_attributes: [
        :id, :field_id, :value, :image, :image_cache, :_destroy, properties: {}
      ]
    )
  end
end
