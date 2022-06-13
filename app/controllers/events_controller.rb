# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event_type, only: %i[new create edit update]
  before_action :set_filters, only: [:index, :download]

  def index
    @pagy, @events = pagy(get_events)
    @templates = policy_scope(::Template.all)
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
      render :edit
    end
  end

  def destroy
    @event = authorize Event.find(params[:id])
    @event.destroy
    flash[:notice] = t("event.destroy_success")

    redirect_to events_url
  end

  def download
    events = get_events

    if events.length > ENV["MAXIMUM_DOWNLOAD_RECORDS"].to_i
      flash[:alert] = t("event.file_size_is_too_big")
      redirect_to events_url
    else
      send_data(EventService.new(events, params[:template_id]).export_csv, filename: "events.csv")
    end
  end

  def unlock
    @event = authorize Event.find(params[:id])
    @event.unlock_access!

    redirect_to events_url
  end

  def search
    @pagy, @events = pagy(policy_scope(Event.search_by_uuid_or_event_type(params[:search])), link_extra: 'data-remote="true"')
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

    def filter_params
      params.permit(
        :uuid, :start_date, :end_date, :filter,
        event_type_ids: [], province_ids: [], risk_levels: [], progresses: [], source_of_informations: []
      ).merge(program_id: current_user.program_id)
    end

    def set_event_type
      @event_types = policy_scope(EventType.all)
    end

    def get_events
      policy_scope(Event.filter(filter_params).order_desc
        .includes(:event_type, :conclude_event_type, :creator,
                  :program, :program_shareds, follow_ups: [:follower, :followee],
                  field_values: { field: :field_options }
                 )
      )
    end

    def set_filters
      return unless current_program.present?

      fields = current_program.fields.includes(:field_options)

      @source_of_informations = fields.select { |f| f.code == "source_of_information" }.first.field_options
      @risk_levels = fields.select { |f| f.code == "risk_level" }.first.field_options
      @event_types = EventType.with_shared(current_program.id).includes(:program, :program_shareds)
      @progresses  = current_program.milestones.pluck(:name)
    end
end
