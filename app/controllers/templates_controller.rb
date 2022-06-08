# frozen_string_literal: true

class TemplatesController < ApplicationController
  def index
    @pagy, @templates = pagy(policy_scope(authorize ::Template.includes(:fields)))
  end

  def new
    @template = authorize current_program.templates.new
  end

  def create
    @template = authorize current_program.templates.new(template_params)

    if @template.save
      redirect_to templates_url
    else
      render :new
    end
  end

  def edit
    @template = authorize current_program.templates.find(params[:id])
  end

  def update
    @template = authorize current_program.templates.find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to templates_url
    else
      render :edit
    end
  end

  def destroy
    @template = authorize current_program.templates.find(params[:id])
    @template.destroy

    redirect_to templates_url
  end

  private
    def template_params
      params.require(:template).permit(:name, :default, properties: [], field_ids: [])
    end
end
