# frozen_string_literal: true

class MedisiesController < ApplicationController
  def index
    @pagy, @medisies = pagy(policy_scope(Medisy.order('created_at ASC').includes(:program)))
  end

  def new
    @medisy = authorize Medisy.new
  end

  def create
    @medisy = authorize Medisy.new(medisys_params)

    if @medisy.save
      redirect_to medisies_url
    else
      render :new
    end
  end

  def edit
    @medisy = authorize Medisy.find(params[:id])
  end

  def update
    @medisy = authorize Medisy.find(params[:id])

    if @medisy.update_attributes(medisys_params)
      redirect_to medisies_url
    else
      render :edit
    end
  end

  def destroy
    @medisy = authorize Medisy.find(params[:id])
    @medisy.destroy

    redirect_to medisies_url
  end

  def help
  end

  private
    def medisys_params
      params.require(:medisy).permit(:name, :url, :program_id)
    end
end
