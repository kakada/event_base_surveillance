module EventTypes
  class FormTypesController < ::ApplicationController
    before_action :assign_event_type

    def index
      @form_types = @event_type.form_types
    end

    def new
      @form_type = FormType.new
    end

    def create
      @form_type = @event_type.form_types.new(form_params)
      if @form_type.save
        redirect_to event_type_forms_url
      else
        render :new
      end
    end

    def edit
      @form_type = FormType.find(params[:id])
    end

    def update
      @form_type = FormType.find(params[:id])

      if @form_type.update_attributes(form_params)
        redirect_to event_type_forms_url
      else
        render :edit
      end
    end

    def destroy
      @form_type = FormType.find(params[:id])
      @form_type.destroy

      redirect_to event_type_forms_url
    end

    private

    def form_params
      params.require(:form).permit(:name, fields_attributes: [:id, :name, :filed_type, :required, :_destroy])
    end

    def assign_event_type
      @event_type = EventType.find(params[:event_type_id])
    end
  end
end
