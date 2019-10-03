require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  let! (:client_app) { create(:client_app) }
  let! (:province) { create(:location)}
  let! (:commune) { create(:location, code: '110402', kind: 'commune')}
  let! (:h5n1) { create(:event_type, program: client_app.program) }
  let! (:influenza) { create(:event_type, name: 'Influenza', program: client_app.program) }
  let  (:event_attributes) {
    {
      "event":{
        "event_type_id": h5n1.id,
        "field_values_attributes":[ {  "field_id":"1", "field_value":"Hello" } ]
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
      put :update, params: { id: event.id, event: {event_type_id: influenza.id} }
    end

    it { expect(response.status).to eq(200) }
    it { expect(event.reload.event_type_id).to eq(influenza.id) }
  end
end
