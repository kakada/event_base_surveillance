# frozen_string_literal: true

class LocationsController < ApplicationController
  def index
    provinces = Location.pumi_provinces(current_user)

    render json: provinces, status: :ok
  end
end
