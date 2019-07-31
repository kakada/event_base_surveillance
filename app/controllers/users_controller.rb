class UsersController < ApplicationController
  def index
    @users = policy_scope(User.includes(:program))
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

  def destroy
    @user = authorize User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :role, :program_id)
  end
end
