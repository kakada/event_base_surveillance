require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  let! (:client_app) { create(:client_app) }
  let! (:province) { create(:location)}
  let! (:commune) { create(:location, code: '110402', kind: 'commune')}
  let! (:event_type) { create(:event_type, program: client_app.program) }
  let  (:event_attributes) {
    {
      "event":{
        "event_type_id": event_type.id,
        "number_of_case": "1",
        "number_of_death": "0",
        "description": "Description about H5N1",
        "event_date": "2019-08-06",
        "report_date": "2019-08-12",
        "province_id": "11",
        "district_id": "1104",
        "commune_id": "110402",
        "village_id": "",
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
    let! (:event)      { create(:event, event_type: event_type, program: client_app.program) }

    before(:each) do
      allow(controller).to receive(:current_program).and_return(event.program)
      put :update, params: { id: event.id, event: {description: 'event description'} }
    end

    it { expect(response.status).to eq(200) }
    it { expect(event.reload.description).to eq('event description') }
  end
end
