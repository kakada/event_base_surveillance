require 'rails_helper'

RSpec.describe Api::V1::Events::FormsController, type: :controller do
  let! (:client_app)    { create(:client_app) }
  let! (:program)    { client_app.program }
  let! (:event_type) { create(:event_type, :with_field, :with_assessment_form_type, program: program) }
  let! (:event)      { create(:event, event_type: event_type, program: client_app.program) }
  let  (:form_attributes) {
    {
      "event_id": event.id,
      "form_type_id": event_type.form_types.first.id,
      "conducted_at":"2019-08-21",
      "field_values_attributes":[ { "field_id": event_type.form_types.first.fields.first.id, "value":"High" } ],
    }
  }

  before(:each) do
    allow(controller).to receive(:restrict_access).and_return(true)
    allow(controller).to receive(:current_client_app).and_return(client_app)
    allow(controller).to receive(:current_program).and_return(event.program)

    post :create, params: { event_id: event.id, form: form_attributes }
  end

  describe 'POST #create' do
    it { expect(response.status).to eq(200) }
  end

  describe 'PUT #update/:id' do
    let (:form) { event.forms.first }

    before(:each) do
      put :update, params: { id: form.id, event_id: event.id, form: {conducted_at: Date.today} }
    end

    it { expect(response.status).to eq(200) }
    it { expect(form.reload.conducted_at).to eq(Date.today) }
  end
end
