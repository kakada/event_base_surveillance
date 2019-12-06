# frozen_string_literal: true

class LocationsController < ApplicationController
  def create
    @location = Location.new(location_params)

    if @location.save
      render json: @location
    else
      render json: { error: @location.errors }, status: :unprocessable_entity
    end
  end


  def update
    @location = Location.find_by(code: params[:id])

    if @location.update_attributes(location_params)
      render json: @location
    else
      render json: { error: @location.errors }, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.require(:location).permit(
      :code, :kind, :latitude, :longitude, :name_en, :name_km
    ).merge(updater_id: current_user.id)
  end
end
