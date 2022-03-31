# frozen_string_literal: true

class MilestonesController < ::ApplicationController
  def index
    @milestones = authorize current_program.milestones.includes(:fields, :message)
  end

  def new
    @milestone = authorize current_program.milestones.new
    @milestone.build_default_section
  end

  def create
    @milestone = authorize current_program.milestones.new(milestone_params)

    if @milestone.save
      redirect_to milestones_url
    else
      render :new
    end
  end

  def edit
    @milestone = authorize Milestone.find(params[:id])
  end

  def update
    @milestone = authorize Milestone.find(params[:id])

    if @milestone.update_attributes(milestone_params)
      redirect_to milestones_url
    else
      render :edit
    end
  end

  def destroy
    @milestone = authorize Milestone.find(params[:id])
    @milestone.destroy

    redirect_to milestones_url
  end

  def reorder
    authorize Milestone, :update?

    current_program.milestones.update_order!(params[:ids])
  end

  private
    def milestone_params
      params.require(:milestone).permit(
        :name, :display_order, :status,
        sections_attributes: [
          :id, :name, :default, :_destroy, :display,
          fields_attributes: [
            :id, :name, :field_type, :required, :display_order, :code, :entry_able,
            :mapping_field_id, :_destroy, :tracking, :description, :relevant, :is_milestone_datetime,
            :template_file, :template_name, :remove_template_file, validations: {},
            field_options_attributes: %i[id name value color _destroy]
          ]
        ]
      ).merge(creator_id: current_user.id)
    end
end
