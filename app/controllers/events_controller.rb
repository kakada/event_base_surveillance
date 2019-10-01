# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @pagy, @events = pagy(policy_scope(Event.includes(:event_milestones).includes(creator: :program)))
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event_types = policy_scope(EventType.all)
    @event = Event.new(event_type_id: params[:event_type_id])
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    @event_types = policy_scope(EventType.all)
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
      :name, :event_type_id, :number_of_case, :number_of_death, :description, :event_date,
      :report_date, :province_id, :district_id, :commune_id, :village_id,
      properties: {},
      field_values_attributes: [
        :id, :field_id, :field_code, :value, :image, :file, :image_cache, :_destroy, properties: {}, values: []
      ]
    )
  end
end
