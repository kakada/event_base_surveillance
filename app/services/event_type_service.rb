# frozen_string_literal: true

class EventTypeService
  def initialize(event_type_id)
    @event_type = EventType.find(event_type_id)
  end

  def clone
    ActiveRecord::Base.transaction do
      @new_event_type = EventType.new(clean_attributes(@event_type))
      @new_event_type.name = "#{@new_event_type.name}_copy_at_#{Time.now}"

      build_event_type_fields
      build_form_types_and_fields

      @new_event_type.save
    end
  end

  private
    def build_event_type_fields
      @event_type.fields.each do |field|
        @new_event_type.fields.new(clean_attributes(field))
      end
    end

    def build_form_types_and_fields
      @event_type.form_types.each do |form_type|
        new_form_type = @new_event_type.form_types.new(clean_attributes(form_type))

        form_type.fields.each do |field|
          new_form_type.fields.new(clean_attributes(field))
        end
      end
    end

    def clean_attributes(object)
      object.attributes.except(*except_attributes)
    end

    def except_attributes
      %w[id created_at updated_at color]
    end
end
