module Events
  class FormsController < ::ApplicationController
    before_action :assign_event

    def new
      @form = @event.forms.new(form_type_id: params[:form_type_id])
    end

    def create
      @form = @event.forms.new(form_params)
      if @form.save
        redirect_to event_url(@event)
      else
        flash.now[:alert] = @form.errors.full_messages
        render :new
      end
    end

    def edit
      @form = Form.find(params[:id])
    end

    def update
      @form = Form.find(params[:id])

      if @form.update_attributes(form_params)
        redirect_to event_url(@event)
      else
        flash.now[:alert] = @form.errors.full_messages
        render :edit
      end
    end

    private

    def form_params
      params.require(:form).permit(
        :submitter_id, :form_type_id, :conducted_at,
        field_values_attributes: [
          :id, :field_id, :value, :image, :image_cache, :_destroy, properties: {}
        ]
      )
    end

    def assign_event
      @event = Event.find(params[:event_id])
    end
  end
end
