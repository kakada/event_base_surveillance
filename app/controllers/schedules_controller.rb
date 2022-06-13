# frozen_string_literal: true

class SchedulesController < ApplicationController
  def index
    @pagy, @schedules = pagy(policy_scope(authorize Schedule.all))
  end

  def new
    @schedule = authorize Schedule.new(type: params[:type])
  end

  def create
    @schedule = authorize Schedule.new(schedule_params)

    if @schedule.save
      redirect_to schedules_url
    else
      render :new
    end
  end

  def edit
    @schedule = authorize Schedule.find(params[:id])
  end

  def update
    @schedule = authorize Schedule.find(params[:id])

    if @schedule.update_attributes(schedule_params)
      redirect_to schedules_url
    else
      render :edit
    end
  end

  def destroy
    @schedule = authorize Schedule.find(params[:id])
    @schedule.destroy

    redirect_to schedules_url
  end

  def activate
    @schedule = authorize Schedule.find(params[:id]), :update?
    @schedule.update(enabled: true)

    flash[:notice] = "Activate successfully"
    redirect_to schedules_url
  end

  def deactivate
    @schedule = authorize Schedule.find(params[:id]), :update?
    @schedule.update(enabled: false)

    flash[:notice] = "Deactivate successfully"
    redirect_to schedules_url
  end

  private
    def schedule_params
      params.require(:schedule)
            .permit(:name, :type, :interval_type, :interval_value,
              :follow_up_hour, :date_number, :message, :emails,
              :date_index, :deadline_duration_in_day,
              channels: []
            ).merge(program_id: current_program.id)
    end
end
