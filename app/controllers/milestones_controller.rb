# frozen_string_literal: true

class MilestonesController < ::ApplicationController
  def index
    @milestones = current_program.milestones.includes(:fields)
  end

  def new
    @milestone = current_program.milestones.new
  end

  def create
    @milestone = current_program.milestones.new(milestone_params)
    if @milestone.save
      redirect_to milestones_url
    else
      render :new
    end
  end

  def edit
    @milestone = Milestone.find(params[:id])
  end

  def update
    @milestone = Milestone.find(params[:id])

    if @milestone.update_attributes(milestone_params)
      redirect_to milestones_url
    else
      render :edit
    end
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    redirect_to milestones_url
  end

  def reorder
    current_program.milestones.update_order!(params[:ids])
  end

  private

  def milestone_params
    params.require(:milestone).permit(
      :name, :display_order, :final,
      fields_attributes: [
        :id, :name, :field_type, :required, :display_order,
        :mapping_field, :mapping_field_type, :_destroy,
        field_options_attributes: %i[
          id name value color _destroy
        ]
      ]
    ).merge(creator_id: current_user.id)
  end
end
