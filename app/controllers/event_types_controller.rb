class EventTypesController < ApplicationController
  def index
    @event_types = EventType.includes(:form_types)
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = current_user.event_types.new(event_type_params)

    if @event_type.save
      redirect_to event_types_url
    else
      render :new
    end
  end

  def edit
    @event_type = EventType.find(params[:id])
  end

  def update
    @event_type = EventType.find(params[:id])

    if @event_type.update_attributes(event_type_params)
      redirect_to event_types_url
    else
      render :edit
    end
  end

  def destroy
    @event_type = EventType.find(params[:id])
    @event_type.destroy

    redirect_to event_types_url
  end

  private

  def event_type_params
    params.require(:event_type).permit(:name)
  end
end
