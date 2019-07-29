module EventTypes
  class FormTypesController < ::ApplicationController
    before_action :assign_event_type

    def index
      @form_types = @event_type.form_types
    end

    def new
      @form_type = @event_type.form_types.new
      return if @event_type.form_types.length > 1

      @form_type.fields.build(name: 'Value', field_type: 'integer', required: true, predefined: true)
      @form_type.fields.build(name: 'Description', field_type: 'text', predefined: true)
      @form_type.fields.build(name: 'Location', field_type: 'location', required: true, predefined: true)
    end

    def create
      @form_type = @event_type.form_types.new(form_type_params)
      if @form_type.save
        redirect_to event_type_form_types_url
      else
        flash.now[:alert] = @form_type.errors.full_messages
        render :new
      end
    end

    def edit
      @form_type = FormType.find(params[:id])
    end

    def update
      @form_type = FormType.find(params[:id])

      if @form_type.update_attributes(form_type_params)
        redirect_to event_type_form_types_url
      else
        flash.now[:alert] = @form_type.errors.full_messages
        render :edit
      end
    end

    def destroy
      @form_type = FormType.find(params[:id])
      @form_type.destroy

      redirect_to event_type_form_types_url
    end

    private

    def form_type_params
      params.require(:form_type).permit(
        :name,
        fields_attributes: [
          :id, :name, :field_type, :required, :display_order, :predefined, :_destroy,
          field_options_attributes: [
            :id, :name, :value, :_destroy
          ]
        ]
      )
    end

    def assign_event_type
      @event_type = EventType.find(params[:event_type_id])
    end
  end
end
