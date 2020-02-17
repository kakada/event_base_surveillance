# frozen_string_literal: true

class TelegramBotsController < ApplicationController
  before_action :set_program

  def show
    @bot = @program.telegram_bot
  end

  def new
    @bot = @program.build_telegram_bot
  end

  def create
    @bot = @program.build_telegram_bot(bot_params)

    if @bot.save
      redirect_to program_telegram_bot_url(@program)
    else
      render :new
    end
  end

  def edit
    @bot = @program.telegram_bot
  end

  def update
    @bot = @program.telegram_bot

    if @bot.update_attributes(bot_params)
      redirect_to program_telegram_bot_url(@program)
    else
      render :edit
    end
  end

  private

  def set_program
    # @program = authorize Program.find(params[:id])
    @program = Program.find(params[:program_id])
  end

  def bot_params
    params.require(:telegram_bot).permit(:token, :username, :actived)
  end
end
