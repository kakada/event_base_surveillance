# frozen_string_literal: true

require "rails_helper"

RSpec.describe MbdsOutbreakReportService do
  let!(:milestone) { create(:milestone) }
  let!(:program) { milestone.program }
  let!(:event_type) { create(:event_type, program: program, name: "Chikungunya", code: "Chikungunya") }
  let!(:user) { create(:user, program: program) }
  let(:service) { MbdsOutbreakReportService.new(user) }

  describe "#upsert_event(report)" do
    let(:report) {
      {
        "id"=>1,
        "user_id"=>73,
        "event_date"=>"2022-07-30T11:58:00.000+07:00",
        "lat"=>nil,
        "lng"=>nil,
        "case_management"=>["clinical_monitor", "isolation"],
        "management_detail"=>"stay at ponheakrek hospital",
        "consulting_detail"=>"",
        "photo1"=>"",
        "photo2"=>"",
        "photo3"=>"",
        "country_id"=>1,
        "province_id"=>25,
        "created_at"=>"2022-07-30T12:18:43.000+07:00",
        "updated_at"=>"2022-07-30T12:18:43.000+07:00",
        "type"=>"HumanEvent",
        "icon"=>"",
        "event_orig"=>nil,
        "eventable"=> {
          "type"=> "human_event",
          "human_event"=> {
            "full_name"=>"Yan Rithkeovimean",
            "age"=>2,
            "gender"=>"Female",
            "occupation"=>"student",
            "supported_history"=>nil,
            "symptoms_list"=>["fever", "headache", "muscle_pain", "abdominal_pain", "skin_lesion"],
            "other_symptom"=>"",
            "laboratory"=>"lab_waiting",
            "provisional_diagnosis"=>[],
            "travel_history"=>"មិនធ្លាប់ទៅណាទេ",
            "past_medical_history"=>"fever , cutaneous rash , ពងទឹកស្បែកលើដៃជើង",
            "past_surgical_history"=>"no"
          }
        }
      }.as_json
    }

    it "create event" do
      expect { service.upsert_event(report) }.to change { Event.count }.by(1)
    end

    context "existing event" do
      let!(:event) { create(:event, program: program, referrer: { source: "mbds", id: 1 }, event_date: 1.month.ago) }

      it "doen't create new" do
        expect { service.upsert_event(report) }.not_to change { Event.count }
      end

      it "update event" do
        service.upsert_event(report)

        expect(event.reload.event_date).to eq(Time.zone.parse(report["event_date"]))
      end
    end
  end
end
