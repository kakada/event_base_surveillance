module EventTypes
  class FormsController < ::ApplicationController
    before_action :assign_event_type

    def index
      @forms = @event_type.forms
    end

    def new
      @form = Form.new
    end

    def create
      @form = @event_type.forms.new(form_params)
      if @form.save
        redirect_to event_type_forms_url
      else
        render :new
      end
    end

    def edit
      @form = Form.find(params[:id])
    end

    def update
      @form = Form.find(params[:id])

      if @form.update_attributes(form_params)
        redirect_to event_type_forms_url
      else
        render :edit
      end
    end

    def destroy
      @form = Form.find(params[:id])
      @form.destroy

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
