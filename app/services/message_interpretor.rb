# frozen_string_literal: true

class MessageInterpretor
  attr_reader :template

  def initialize(template, event_uuid, event_milestone_id = nil)
    # "Hi all! There is {{de_event_type_name}} happen in {{de_location}}, so please consider it. The source is from {{dy_1_source_of_information}}"
    @template = template
    @event = Event.find_by(uuid: event_uuid)
    @event_milestone = @event.event_milestones.find(event_milestone_id) if event_milestone_id.present?
  end

  def message
    @message = template
    validate_from_default_field(@event, 'de_')
    validate_from_dynamic_field(@event, 'dy_')
    validate_from_default_field(@event_milestone, 'emde_')
    validate_from_dynamic_field(@event_milestone, 'emdy_')
    @message
  end

  private

  def validate_from_default_field(obj, obj_code)
    return if obj.nil?

    default_fields = select_elements_starting_with(fields, obj_code)
    default_fields.each do |field|
      field_name  = field.split(obj_code)[1]
      field_value = obj.send(field_name).to_s
      field_template = "{{#{field}}}"

      @message = @message.gsub(/#{field_template}/, field_value)
    end
  end

  def validate_from_dynamic_field(obj, obj_code)
    return if obj.nil?

    dynamic_fields = select_elements_starting_with(fields, obj_code)
    dynamic_fields.each do |field|
      field_id = field.split('_')[1].to_i
      fv       = obj.field_values.select{ |fv| fv.field_id == field_id }.first
      field_value    = fv.try(:value) || fv.try(:values) || fv.try(:image_url) || fv.try(file_url)
      field_template = "{{#{field}}}"

      @message = @message.gsub(/#{field_template}/, field_value)
    end
  end

  # ["de_event_type", "de_location", "dy_1_source_of_information"]
  def fields
    @fields ||= template.scan(/{{([^}]*)}}/).flatten
  end

  def select_elements_starting_with(arr, letter)
    arr.select { |str| str.start_with?(letter) }
  end
end
