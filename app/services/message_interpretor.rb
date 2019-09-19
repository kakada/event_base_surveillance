# frozen_string_literal: true

class MessageInterpretor
  attr_reader :template

  def initialize(template, event_uuid, event_milestone_id = nil)
    # "Hi all! There is {{d_event_type_name}} happen in {{d_location}}, so please consider it."
    @template = template
    @event = Event.find_by(uuid: event_uuid)
    @event_milestone = @event.event_milestones.find(event_milestone_id) if event_milestone_id.present?
  end

  def message; end

  private

  def sms_from_default_field
    # ["d_event_type", "d_location"]
    fields = template.scan(/{{([^}]*)}}/).flatten

    # ["event_type", "location"]
    default_fields = fields.map { |f| f.gsub(/^d\_/, '') }

    # [{:field=>"event_type_name", :value=>"Influenza"}, {:field=>"location", :value=>"កំពង់ចាម"}]
    arr = default_fields.map { |field| { field: "{{d_#{field}}}", value: @event.send(field) } }

    sms = template
    arr.each do |a|
      sms = sms.gsub(/#{a[:field]}/, a[:value])
    end

    sms
  end

  def sms_from_dynamic_field; end
end
