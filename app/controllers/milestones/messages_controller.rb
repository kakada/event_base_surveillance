# frozen_string_literal: true

module Milestones
  class MessagesController < ::ApplicationController
    before_action :set_milestone
    before_action :set_chat_group

    def show
      @message = @milestone.message
    end

    def new
      @message = @milestone.build_message
      @message.build_telegram
      @message.build_telegram.notification_chat_groups.build
      @message.build_email_notification
    end

    def create
      @message = @milestone.build_message(message_params)

      if @message.save
        redirect_to milestone_message_url(@milestone)
      else
        flash.now[:alert] = @message.errors.full_messages
        render :new
      end
    end

    def edit
      @message = @milestone.message
      @message.build_telegram if @message.telegram.nil?
      @message.build_telegram.notification_chat_groups.build if @message.telegram.notification_chat_groups.empty?
      @message.build_email_notification if @message.email_notification.nil?
    end

    def update
      @message = @milestone.message

      if @message.update_attributes(message_params)
        redirect_to milestone_message_url(@milestone)
      else
        flash.now[:alert] = @message.errors.full_messages
        render :edit
      end
    end

    private
      def message_params
        params.require(:message).permit(:message,
          telegram_attributes:
          [
            :milestone_id,
            notification_chat_groups_attributes: [:id, :chat_group_id]
          ],
          email_notification_attributes: [:id, :emails]
        )
      end

      def set_milestone
        @milestone = Milestone.find(params[:milestone_id])
      end

      def set_chat_group
        @chat_groups = ChatGroup.telegrams
      end
  end
end
