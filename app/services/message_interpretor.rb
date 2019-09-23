# frozen_string_literal: true

class MessageInterpretor
  attr_reader :template

  def initialize(template, event_uuid, event_milestone_id = nil)
    @template = template
    @event = Event.find_by(uuid: event_uuid)
    @event_milestone = @event.event_milestones.find(event_milestone_id) if event_milestone_id.present?
  end

  def message
    @message = template
    process_message_from_event
    process_message_from_event_milestone
    @message
  end

  private

  def process_message_from_event
    validate_from_default_field(@event, Event.default_template_code)
    validate_from_dynamic_field(@event, Event.dynamic_template_code)
  end

  def process_message_from_event_milestone
    validate_from_default_field(@event_milestone, EventMilestone.default_template_code)
    validate_from_dynamic_field(@event_milestone, EventMilestone.dynamic_template_code)
  end

  def validate_from_default_field(obj, template_code)
    return if obj.nil?

    default_fields = select_elements_starting_with(fields, template_code)
    default_fields.each do |field|
      field_name  = field.split(template_code)[1]
      field_value = obj.send(field_name).to_s
      field_template = "{{#{field}}}"

      @message = @message.gsub(/#{field_template}/, field_value)
    end
  end

  def validate_from_dynamic_field(obj, template_code)
    return if obj.nil?

    dynamic_fields = select_elements_starting_with(fields, template_code)
    dynamic_fields.each do |field|
      field_id = field.split('_')[1].to_i
      fv       = obj.field_values.select { |field_value| field_value.field_id == field_id }.first
      field_value = fv.try(:value) || fv.try(:values) || fv.try(:image_url) || fv.try(:file_url)
      field_template = "{{#{field}}}"

      @message = @message.gsub(/#{field_template}/, field_value.to_s)
    end
  end

  def fields
    @fields ||= template.scan(/{{([^}]*)}}/).flatten
  end

  def select_elements_starting_with(arr, letter)
    arr.select { |str| str.start_with?(letter) }
  end
end
