# frozen_string_literal: true

class EventMilestoneMessageInterpreter
  attr_reader :event_milestone, :message

  def initialize(event_milestone, message)
    @event_milestone = event_milestone
    @message = message
  end

  def interpreted_message
    sms = message
    embeded_fields.each do |embeded_field|
      sms = sms.gsub(/#{"{{" + embeded_field + "}}"}/, get_field_value(embeded_field).to_s)
    end
    sms
  end

  private
    def get_field_value(field)
      variables[field.to_sym]
    end

    def embeded_fields
      @embeded_fields ||= message.scan(/{{([^}]*)}}/).flatten.uniq
    end

    def variables
      {
        event_uuid: event_milestone.event_uuid,
        milestone_name: event_milestone.milestone.name,
        submitter_email: event_milestone.submitter.email,
        event_url: Rails.application.routes.url_helpers.event_url(event_milestone.event, host: ENV["HOST_URL"])
      }
    end
end
