# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(policy_scope(authorize User.filter(params).order(updated_at: :DESC).includes(:program, :location)))
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

    if @user.update_attributes(user_params)
      redirect_to users_url
    else
      flash.now[:alert] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = authorize User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  def update_locale
    current_user.language_code = locale_params[:language_code]
    if current_user.save
      head :ok
    else
      render json: current_user.errors.messages
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :full_name, :role, :program_id, :province_code, :phone_number)
    end

    def locale_params
      params.require(:user).permit(:language_code)
    end
end
