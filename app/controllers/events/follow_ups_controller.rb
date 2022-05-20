# frozen_string_literal: true

module Events
  class FollowUpsController < ::ApplicationController
    before_action :set_event

    def new
      @follow_up = @event.follow_ups.new(channels: FollowUp::CHANNELS)

      respond_to do |format|
        format.js
      end
    end

    def create
      @follow_up = @event.follow_ups.new(follow_up_params)

      respond_to do |format|
        format.js {
          if @follow_up.save
            flash[:notice] = "The follow up message is created successfully!"
          else
            flash[:alert] = "Fail to create follow up message!"
          end
        }
      end
    end

    private
      def set_event
        @event = Event.find(params[:event_id])
      end

      def follow_up_params
        params.require(:follow_up).permit(:message, channels: [])
              .merge(follower_id: current_user.id, followee_id: @event.creator_id)
      end
  end
end
