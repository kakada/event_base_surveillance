class EventsController < ApplicationController
  def index
    @event_types = EventType.includes(:form_types)
    @events = Event.includes(:forms)
  end

  def new
    @event = Event.new(event_type_id: params[:event_type_id])
    @form_type = FormType.find_by(event_type_id: params[:event_type_id])
  end

  def edit
    @event = Event.find(params[:id])
    @form_type = FormType.find_by(event_type_id: @event.event_type_id)
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attibutes(event_params)
      redirect_to events_url
    else
      render :edit
    end
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to events_url
    else
      render :new
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
      :name, :event_type_id,
      forms_attributes: [ :submitter_id, :form_type_id, properties: {} ]
    )
  end
end
