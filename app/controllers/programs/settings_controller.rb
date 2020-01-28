# frozen_string_literal: true

module Programs
  class SettingsController < ::ApplicationController
    def show; end

    def update
      @program = authorize current_program

      if @program.update_attributes(program_params)
        render json: @program
      else
        render json: { errors: @program.errors }
      end
    end

    private

    def program_params
      params.require(:program).permit(
        :enable_telegram, :enable_email_notification, :language_code
      )
    end
  end
end
