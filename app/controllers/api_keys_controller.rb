class ApiKeysController < ApplicationController
  def index
    @api_keys = ApiKey.all
  end

  def new
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(api_key_params)

    if @api_key.save
      redirect_to api_keys_url
    else
      render :new
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])
  end

  def update
    @api_key = ApiKey.find(params[:id])

    if @api_key.update_attributes(api_key_params)
      redirect_to api_keys_url
    else
      render :edit
    end
  end

  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy
    redirect_to api_keys_url
  end

  def deactivate
    @api_key = ApiKey.find(params[:id])
    @api_key.update_attributes(active: false)

    flash[:notice] = 'set shared successfully'
    redirect_to api_keys_url
  end

  def activate
    @api_key = ApiKey.find(params[:id])
    @api_key.update_attributes(active: true)

    flash[:notice] = 'set shared successfully'
    redirect_to api_keys_url
  end

  private

  def api_key_params
    params.require(:api_key).permit(:ip_address, :name, :access_token, permissions: [])
  end
end
