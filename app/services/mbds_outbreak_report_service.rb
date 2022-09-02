# frozen_string_literal: true

class MbdsOutbreakReportService
  include HTTParty
  base_uri ENV["MBDS_BASE_URI"]

  CAMBODIA_ID = 1

  def initialize(user, from_date = Date.yesterday.to_s, till_date = Date.today.to_s)
    @user = user
    @program = user.program
    @fields = @program.milestones.root.fields
    @from_date = from_date
    @till_date = till_date
  end

  def process
    reports.each do |report|
      upsert_event(report)
    end
  end

  def reports
    options = {
      access_token: access_token,
      event_type: "human_event",
      country_id: CAMBODIA_ID,
      from_date: @from_date,
      till_date: @till_date
    }

    self.class.get("/api/events?#{options.to_query}").parsed_response["data"]
  end

  def upsert_event(report)
    referrer = { source: "mbds", id: report["id"] }

    @event = @program.events.find_or_initialize_by(referrer: referrer)
    @event.update(event_params(report))
  end

  def access_token
    @access_token ||= get_token
  end

  private
    def get_token
      options = { grant_type: "password", username: ENV["MBDS_USERNAME"], password: ENV["MBDS_PASSWORD"] }

      self.class.post("/oauth/token",
        body: options.to_query,
        headers: {
          "Content-Type" => "application/x-www-form-urlencoded",
          "charset" => "utf-8"
        }
      ).parsed_response["access_token"]
    end

    def event_params(report)
      {
        event_type_id: event_type(report).id,
        creator_id: @user.id,
        field_values_attributes: [
          field_value("number_of_case", 1),
          field_value("description", description(report)),
          field_value("province_id", format("%02d", report["province_id"])),
          field_value("event_date", report["event_date"]),
          field_value("report_date", report["created_at"]),
          field_value("source_of_information", "MBDS")
        ]
      }
    end

    def event_type(report)
      names = report["eventable"]["human_event"]["provisional_diagnosis"] + ["unknown"]

      @program.event_types.select { |evt| names.include? evt.name.downcase }.first
    end

    def field_value(field_code, value)
      field = @fields.select { |f| f.code == field_code }.first
      fv = @event.get_value_by_code(field_code)

      { id: fv.try(:id), field_id: field.id, field_code: field.code, value: value }
    end

    def description(report)
      str = [desc("id", report["id"])]

      str += %w(provisional_diagnosis symptoms_list).map do |field|
        desc(field, report["eventable"]["human_event"][field])
      end

      str.compact.join(". ")
    end

    def desc(name, value)
      return nil unless value.present?

      value = value.join(", ") if value.kind_of?(Array)

      I18n.t("mbds.#{name}") + ": #{value}"
    end
end
