# frozen_string_literal: true

class MilestonesController < ::ApplicationController
  def index
    @milestones = current_program.milestones.includes(:milestone_attributes)
  end

  def new
    @milestone = current_program.milestones.new
  end

  def create
    @milestone = current_program.milestones.new(milestone_params)
    if @milestone.save
      redirect_to milestones_url
    else
      flash.now[:alert] = @milestone.errors.full_messages
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
      flash.now[:alert] = @milestone.errors.full_messages
      render :edit
    end
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    redirect_to milestones_url
  end

  private

  def milestone_params
    params.require(:milestone).permit(
      :name, :display_order,
      milestone_attributes_attributes: [
        :id, :name, :kind, :required, :display_order,
        :mapping_field, :mapping_field_type, :_destroy,
        milestone_attribute_options_attributes: %i[
          id name value color _destroy
        ]
      ]
    )
  end
end
