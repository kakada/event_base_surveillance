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
      redirect_to event_types_url(@event_type)
    else
      flash.now[:alert] = @event_type.errors.full_messages
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
      flash.now[:alert] = @event_type.errors.full_messages
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
    params.require(:event_type).permit(
      :name,
      fields_attributes: [
        :id, :name, :field_type, :required, :display_order, :predefined, :_destroy,
        field_options_attributes: [
          :id, :name, :value, :_destroy
        ]
      ]
    )
  end
end
