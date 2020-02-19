# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  let! (:client_app) { create(:client_app) }
  let! (:program) { client_app.program }
  let! (:province) { create(:location) }
  let! (:commune) { create(:location, code: '110402', kind: 'commune') }
  let! (:h5n1) { create(:event_type, program: program) }
  let! (:influenza) { create(:event_type, name: 'Influenza', program: program) }
  let  (:event_attributes) {
    field_values = {
      province_id: province.code,
      number_of_case: rand(1..5),
      event_date: Date.today - rand(0..30),
      report_date: Date.today
    }

    field_values_attributes = field_values.map do |k, v|
      {
        field_id: program.milestones.root.fields.find_by(code: k.to_s).id,
        field_code: k,
        value: v
      }
    end

    {
      "event": {
        "event_type_id": h5n1.id,
        "field_values_attributes": field_values_attributes
      }
    }
  }

  before(:each) do
    allow(controller).to receive(:restrict_access).and_return(true)
    allow(controller).to receive(:current_client_app).and_return(client_app)
  end

  describe 'POST #create' do
    it 'creates an event' do
      post :create, params: event_attributes

      expect(response.status).to eq(200)
    end
  end

  describe 'PUT #update/:id' do
    let! (:event)      { create(:event, event_type: h5n1, program: client_app.program) }

    before(:each) do
      allow(controller).to receive(:current_program).and_return(event.program)
      put :update, params: { id: event.id, event: { event_type_id: influenza.id } }
    end

    it { expect(response.status).to eq(200) }
    it { expect(event.reload.event_type_id).to eq(influenza.id) }
  end
end
