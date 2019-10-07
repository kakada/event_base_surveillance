# frozen_string_literal: true

class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def new
    @program = authorize Program.new
  end

  def create
    @program = authorize Program.new(program_params)

    if @program.save
      @program.milestones.create_root

      redirect_to programs_url
    else
      render :new
    end
  end

  def edit
    @program = authorize Program.find(params[:id])
  end

  def update
    @program = authorize Program.find(params[:id])

    if @program.update_attributes(program_params)
      redirect_to programs_url
    else
      render :edit
    end
  end

  def destroy
    @program = authorize Program.find(params[:id])
    @program.destroy

    redirect_to programs_url
  end

  private

  def program_params
    params.require(:program).permit(:name)
  end
end
