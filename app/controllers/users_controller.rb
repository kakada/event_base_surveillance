# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :clear_flash, on: [:update]

  def index
    @pagy, @users = pagy(policy_scope(authorize User.filter(filter_params).order(updated_at: :DESC).includes(:program, :location)))
  end

  def show
    authorize current_user

    respond_to do |format|
      format.js
    end
  end

  def new
    @user = authorize User.new
  end

  def create
    @user = authorize User.new(user_params)

    if @user.save
      UserWorker.perform_async(@user.id)
      redirect_to users_url
    else
      flash.now[:alert] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = authorize User.find(params[:id])
  end

  def update
    @user = authorize User.find(params[:id])

    respond_to do |format|
      format.html {
        if @user.update(user_params)
          redirect_to users_url
        else
          flash.now[:alert] = @user.errors.full_messages
          render :edit
        end
      }

      format.js {
        @user.update(user_params)

        if @user.notification_channels.present?
          flash[:notice] = t("user.notification_channels", channels: @user.notification_channels.map { |ch| I18n.t("shared.#{ch}") }.join(", "))
        else
          flash[:alert] = t("user.no_notification_channels")
        end
      }
    end
  end

  def destroy
    @user = authorize User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  def disconnect_telegram
    @user = authorize User.find(params[:id]), :update?

    respond_to do |format|
      format.js {
        @user.disconnect_telegram

        flash[:notice] = t("user.disconnect_telegram_successfully")
      }
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :full_name, :role,
        :program_id, :province_code, :phone_number, notification_channels: []
      )
    end

    def filter_params
      params.permit(:email, province_ids: [])
    end

    def clear_flash
      flash.clear
    end
end
