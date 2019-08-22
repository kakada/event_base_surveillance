require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  # let! (:api_key)    { create(:api_key) }
  # let! (:program)    { api_key.program }
  # let! (:event_type) { create(:event_type, :with_field, :with_assessment_form_type, program: program) }
  let  (:event_attributes) {
    {
      "event":{
        "event_type_id":"1",
        "value":"1",
        "description":"Description about H5N1",
        "event_date":"2019-08-06",
        "report_date":"2019-08-12",
        "province_id":"11",
        "district_id":"1104",
        "commune_id":"110402",
        "village_id":"",
        "field_values_attributes":[ {  "field_id":"1", "field_value":"Hello" } ],
        "forms_attributes":[
           {
              "conducted_at":"2019-08-21",
              "field_values_attributes":[ { "field_id":"2", "value":"High" } ]
           }
        ]
      }
    }
  }

  describe 'POST #create' do
    let! (:api_key)    { create(:api_key) }
    let! (:program)    { api_key.program }
    let! (:event_type) { create(:event_type, :with_field, :with_assessment_form_type, program: program) }

    before(:each) do
      controller.stub(:restrict_access).and_return(true)
      controller.stub(:current_api_key).and_return(api_key)
    end

    it 'creates an event' do
      post :create, params: event_attributes

      expect(response.status).to eq(200)
    end
  end

  describe 'PUT #update/:id' do
    # let! (:api_key)    { create(:api_key) }
    # let! (:program)    { api_key.program }
    # let! (:event_type) { create(:event_type, :with_field, :with_assessment_form_type, program: program) }
    # let! (:event)      { create(:event, event_type: event_type, program: program) }

    # before(:each) do
    #   @api_key = create(:api_key)
    #   @program = @api_key.program
    #   @event_type = create(:event_type, :with_field, :with_assessment_form_type) do |event_type|
    #     event_type.program = @program
    #   end
    #   # @event = create(:event, event_type: @event_type, program: @program)
    #   @event = create(:event) do |event|
    #     event.program = @program
    #   end

    #   controller.stub(:restrict_access).and_return(true)
    #   controller.stub(:current_api_key).and_return(@api_key)
    #   # controller.stub(:current_program).and_return(@program)
    # end

    # it 'updates the event' do
    #   api_key = create(:api_key)
    #   program = api_key.program
    #   event_type = create(:event_type, program: program)
    #   event = create(:event, program: program)
    #   # byebug

    #   controller.stub(:restrict_access).and_return(true)
    #   controller.stub(:current_api_key).and_return(api_key)

    #   put :update, params: { id: event.id, event: {description: 'event description'} }
    #   expect(response.status).to eq(200)
    # end
  end
end
