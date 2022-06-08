# frozen_string_literal: true

class LocalesController < ApplicationController
  def update
    if current_user.update(locale_params)
      head :ok
    else
      render json: current_user.errors.messages
    end
  end

  private
    def locale_params
      params.require(:user).permit(:locale)
    end
end
