# frozen_string_literal: true

class ScheduleMessageInterpreter
  attr_reader :schedule, :message

  def initialize(schedule_id, event_uuid)
    @schedule = ::Schedule.find_by id: schedule_id
    @event = ::Event.find_by uuid: event_uuid
    @message = @schedule.try(:message)
  end

  def interpreted_message
    return "" if schedule.nil? || message.blank?

    sms = message
    embeded_fields.each do |embeded_field|
      sms = sms.gsub(/#{"{{" + embeded_field + "}}"}/, get_field_value(embeded_field).to_s)
    end
    sms
  end

  private
    def get_field_value(embeded_field)
      model = embeded_field.split(".")[0]
      field = embeded_field.split(".")[1]
      value = "ScheduleMessages::#{model.camelcase}Interpreter".constantize.new(schedule, @event).load(field)

      "<b>#{value}</b>"
      rescue
        Rails.logger.warn "Model #{model} and field #{field} is unknwon"
        ""
    end

    def embeded_fields
      @embeded_fields ||= message.scan(/{{([^}]*)}}/).flatten.uniq
    end
end
