# frozen_string_literal: true

class WebhooksController < ApplicationController
  before_action :set_event_types, only: %i[new create edit update]

  def index
    @pagy, @webhooks = pagy(policy_scope(Webhook.all))
  end

  def new
    @webhook = Webhook.new
  end

  def create
    @webhook = current_program.webhooks.new(webhook_params)

    if @webhook.save
      redirect_to webhooks_url
    else
      render :new
    end
  end

  def edit
    @webhook = Webhook.find(params[:id])
  end

  def update
    @webhook = Webhook.find(params[:id])

    if @webhook.update_attributes(webhook_params)
      redirect_to webhooks_url
    else
      render :edit
    end
  end

  def destroy
    @webhook = Webhook.find(params[:id])
    @webhook.destroy

    redirect_to webhooks_url
  end

  private

  def webhook_params
    params.require(:webhook).permit(:name, :token, :username, :password, :type, :url, event_type_ids: [])
  end

  def set_event_types
    @event_types = current_program.event_types
  end
end
