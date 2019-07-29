class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)

    if @program.save
      redirect_to programs_url
    else
      render :new
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])

    if @program.update_attributes(program_params)
      redirect_to programs_url
    else
      render :edit
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    redirect_to programs_url
  end

  private

  def program_params
    params.require(:program).permit(:name)
  end
end
