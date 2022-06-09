# frozen_string_literal: true

require "rails_helper"

RSpec.describe ScheduleMessageInterpreter do
  describe "interpreted_message" do
    let(:schedule) { create(:schedule) }
    let(:event) { create(:event, program: schedule.program) }

    context "no schedule" do
      let(:interpreter) { ScheduleMessageInterpreter.new(nil, event) }

      it "return empty string" do
        expect(interpreter.interpreted_message).to eq("")
      end
    end

    context "invalid template code" do
      let(:interpreter) { ScheduleMessageInterpreter.new(schedule, event) }

      context "wrong curly brackets" do
        let(:invalid_message) { "Your event {event.uuid}" }

        before { schedule.update(message: invalid_message) }

        it "doen't interpret message" do
          expect(interpreter.interpreted_message).to eq(invalid_message)
        end
      end

      context "wrong field_code" do
        let(:invalid_message) { "Your event {{event.code}}" }

        before { schedule.update(message: invalid_message) }

        it "returns nil for wrong field" do
          expect(interpreter.interpreted_message).to eq("Your event ")
        end
      end
    end

    context "valid template code" do
      let(:interpreter) { ScheduleMessageInterpreter.new(schedule, event) }
      let(:url) { Rails.application.routes.url_helpers.event_url(event, host: ENV['HOST_URL'])}
      let(:display_message) { "Your created event <b>#{event.uuid}</b> has been keep a part for a while. Your last update date <b>#{event.updated_at}</b> on step on the event is <b>#{event.progress}</b>. Would you consider to update next progress? <b><a href='#{url}'>#{url}</a></b>" }

      it { expect(interpreter.interpreted_message).to eq(display_message) }
    end
  end
end
