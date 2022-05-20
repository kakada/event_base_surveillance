# frozen_string_literal: true

module Programs
  class IntervalFollowUpsController < ::ApplicationController
    def show
      @follow_up = current_program.interval_follow_up
    end

    def update
      @follow_up = current_program.interval_follow_up

      respond_to do |format|
        if @follow_up.update(interval_follow_up_params)
          format.js { redirect_to setting_url }
        else
          format.js
        end
      end

    end

    private
      def interval_follow_up_params
        params.require(:interval_follow_up).permit(:enabled, :duration_in_day, :duration_in_hour, channels: [])
      end
  end
end
