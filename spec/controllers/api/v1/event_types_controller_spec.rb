require 'rails_helper'

RSpec.describe Api::V1::EventTypesController, type: :controller do
  let! (:client_app) { create(:client_app) }
  let! (:event_type) { create(:event_type, :with_field, :with_assessment_form_type, program: client_app.program) }

  before(:each) do
    allow(controller).to receive(:restrict_access).and_return(true)
    allow(controller).to receive(:current_client_app).and_return(client_app)
    allow(controller).to receive(:current_program).and_return(event_type.program)
  end

  describe 'GET #index' do
    before(:each) do
      get :index
    end

    it { expect(JSON.parse(response.body)['event_types']).not_to be_nil }
    it { expect(JSON.parse(response.body)['meta']).not_to be_nil }
    it { expect(response.status).to eq(200) }
  end
end
