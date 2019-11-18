# frozen_string_literal: true

class ClientAppsController < ApplicationController
  def index
    @client_apps = policy_scope(ClientApp.all)
  end

  def new
    @client_app = ClientApp.new
  end

  def create
    @client_app = current_program.client_apps.new(client_app_params)
    authorize @client_app

    if @client_app.save
      redirect_to client_apps_url
    else
      render :new
    end
  end

  def edit
    @client_app = ClientApp.find(params[:id])
  end

  def update
    @client_app = current_program.client_apps.find(params[:id])
    authorize @client_app

    if @client_app.update_attributes(client_app_params)
      redirect_to client_apps_url
    else
      render :edit
    end
  end

  def destroy
    @client_app = ClientApp.find(params[:id])
    authorize @client_app

    @client_app.destroy
    redirect_to client_apps_url
  end

  def deactivate
    @client_app = ClientApp.find(params[:id])
    authorize @client_app, :update?

    @client_app.update_attributes(active: false)
    flash[:notice] = 'deactivate successfully'
    redirect_to client_apps_url
  end

  def activate
    @client_app = ClientApp.find(params[:id])
    authorize @client_app, :update?

    @client_app.update_attributes(active: true)
    flash[:notice] = 'activate successfully'
    redirect_to client_apps_url
  end

  def info; end

  private

  def client_app_params
    params.require(:client_app).permit(:ip_address, :name, :access_token, permissions: [])
  end
end
