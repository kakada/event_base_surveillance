# frozen_string_literal: true

module Milestones
  class TelegramsController < ::ApplicationController
    before_action :set_milestone
    before_action :set_chat_group, only: %i[new edit]

    def show
      @telegram = @milestone.telegram
    end

    def new
      @telegram = @milestone.build_telegram
    end

    def create
      @telegram = @milestone.build_telegram(telegram_params)

      if @telegram.save
        redirect_to milestone_telegram_url(@milestone)
      else
        flash.now[:alert] = @telegram.errors.full_messages
        render :new
      end
    end

    def edit
      @telegram = @milestone.telegram
    end

    def update
      @telegram = @milestone.telegram

      if @telegram.update_attributes(telegram_params)
        redirect_to milestone_telegram_url(@milestone)
      else
        flash.now[:alert] = @telegram.errors.full_messages
        render :edit
      end
    end

    private

    def telegram_params
      params.require(:notifications_telegram).permit(
        :message, chat_group_ids: []
      )
    end

    def set_milestone
      @milestone = Milestone.find(params[:milestone_id])
    end

    def set_chat_group
      @groups = ChatGroup.telegrams
    end
  end
end
