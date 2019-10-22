require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to belong_to(:creator).class_name('User').optional }
  it { is_expected.to have_many(:event_milestones).dependent(:destroy) }
  it { is_expected.to have_many(:field_values).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:event_type_id) }

  describe 'assign_location' do
    before :each do
      @province = Location.first || create(:location)
      @district = create :location, code: '0102', latitude: 0.1, longitude: 0.5
      @commune = create :location, code: '010201', latitude: 0.13, longitude: 0.51
      @village = create :location, code: '01020101', latitude: 0.132, longitude: 0.512

      @event = create(:event)
      @root_fields = @event.program.milestones.root.fields
    end

    it 'should set province geo point on create' do
      expect(@event.location_code).to eq(@province.code)
    end

    it 'should set district geo point on update' do
      field = @root_fields.find_by(code: 'district_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @district.code)
      @event.save

      expect(@event.location_code).to eq(@district.code)
    end

    it 'should set commune geo point on update' do
      field = @root_fields.find_by(code: 'commune_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @commune.code)
      @event.save

      expect(@event.location_code).to eq(@commune.code)
    end

    it 'should set village geo point on update' do
      field = @root_fields.find_by(code: 'village_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @village.code)
      @event.save

      expect(@event.location_code).to eq(@village.code)
    end
  end
end
