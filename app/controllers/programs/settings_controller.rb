# frozen_string_literal: true

module Programs
  class SettingsController < ::ApplicationController
    def show; end

    def update
      @program = authorize current_program

      respond_to do |format|
        if @program.update_attributes(program_params)
          format.html { redirect_to setting_path }
          format.json { render json: @program }
        else
          format.html { redirect_to setting_path, alert: @program.errors.full_messages }
          format.json { render json: { errors: @program.errors } }
        end
      end
    end

    private
      def program_params
        params.require(:program).permit(
          :enable_email_notification, :language_code, :unlock_event_duration, :logo,
          telegram_bot_attributes: [
            :token, :username, :enabled
          ]
        )
      end
  end
end
