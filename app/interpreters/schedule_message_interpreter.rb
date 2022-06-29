# frozen_string_literal: true

class ScheduleMessageInterpreter
  attr_reader :schedule, :event

  def initialize(schedule, event = nil)
    @schedule = schedule
    @event = event
  end

  def interpreted_message
    return "" if schedule.nil?

    sms = schedule.message
    embeded_fields.each do |embeded_field|
      sms = sms.gsub(/#{"{{" + embeded_field + "}}"}/, get_field_value(embeded_field).to_s)
    end
    sms
  end

  private
    def get_field_value(embeded_field)
      model = embeded_field.split(".")[0]
      field = embeded_field.split(".")[1]
      value = "ScheduleMessages::#{model.camelcase}Interpreter".constantize.new(schedule, event).load(field)

      "#{value}"
      rescue
        Rails.logger.warn "Model #{model} and field #{field} is unknwon"
        ""
    end

    def embeded_fields
      @embeded_fields ||= schedule.message.scan(/{{([^}]*)}}/).flatten.uniq
    end
end
