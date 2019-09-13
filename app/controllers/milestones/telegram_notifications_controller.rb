# frozen_string_literal: true

module Milestones
  class TelegramNotificationsController < ::ApplicationController
    before_action :set_milestone
    before_action :set_telegram_chat, only: [:new, :edit]

    def show
      @telegram = @milestone.telegram_notification
    end

    def new
      @telegram = @milestone.build_telegram_notification
    end

    def create
      @telegram = @milestone.build_telegram_notification(telegram_params)

      if @telegram.save
        redirect_to milestone_telegram_notification_url(@milestone)
      else
        flash.now[:alert] = @telegram.errors.full_messages
        render :new
      end
    end

    def edit
      @telegram = @milestone.telegram_notification
    end

    def update
      @telegram = @milestone.telegram_notification

      if @telegram.update_attributes(telegram_params)
        redirect_to milestone_telegram_notification_url(@milestone)
      else
        flash.now[:alert] = @telegram.errors.full_messages
        render :edit
      end
    end

    private

    def telegram_params
      params.require(:telegram_notification).permit(
        :message, chat_ids: []
      )
    end

    def set_milestone
      @milestone = Milestone.find(params[:milestone_id])
    end

    def set_telegram_chat
      @chats = TelegramBot.new.chats
    end
  end
end
