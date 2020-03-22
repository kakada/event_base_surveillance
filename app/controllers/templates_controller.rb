class TemplatesController < ApplicationController
  def index
    @templates = current_program.templates.includes(:fields)
  end

  def new
    @template = current_program.templates.new
  end

  def create
    @template = current_program.templates.new(template_params)

    if @template.save
      redirect_to templates_url
    else
      render :new
    end
  end

  def edit
    @template = current_program.templates.find(params[:id])
  end

  def update
    @template = current_program.templates.find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to templates_url
    else
      render :edit
    end
  end

  def destroy
    @template = current_program.templates.find(params[:id])
    @template.destroy

    redirect_to templates_url
  end

  private
    def template_params
      params.require(:template).permit(:name, :default, properties: [], field_ids: [])
    end
end
