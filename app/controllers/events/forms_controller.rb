module Events
  class FormsController < ::ApplicationController
    before_action :assign_event

    def index
      @forms = @event.forms
    end

    def new
      @form = Form.new(event_id: params[:event_id])
    end

    def create
      @form = @event.form_types.new(form_params)
      if @form.save
        redirect_to event_forms_url
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
        redirect_to event_forms_url
      else
        render :edit
      end
    end

    def destroy
      @form = Form.find(params[:id])
      @form.destroy

      redirect_to event_forms_url
    end

    private

    def form_params
      params.require(:form).permit(:submitter_id, :form_type_id, properties: {})
    end

    def assign_event
      @event = Event.find(params[:event_id])
    end
  end
end
