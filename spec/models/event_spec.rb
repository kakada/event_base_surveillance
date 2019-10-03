require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type).optional }
  it { is_expected.to belong_to(:creator).class_name('User').optional }
  it { is_expected.to have_many(:event_milestones).dependent(:destroy) }
  it { is_expected.to have_many(:field_values).dependent(:destroy) }

  describe 'assign_geo_point' do
    before :all do
      @province = FactoryBot.create :location
      @district = FactoryBot.create :location, code: '0102', latitude: 0.1, longitude: 0.5
      @commune = FactoryBot.create :location, code: '010201', latitude: 0.13, longitude: 0.51
      @village = FactoryBot.create :location, code: '01020101', latitude: 0.132, longitude: 0.512

      @root_milestone = FactoryBot.create :milestone, :root
      @event = FactoryBot.create :event
    end

    it 'should set province geo point on create' do
      field = @root_milestone.fields.find_by(code: 'province_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @province.code)
      @event.save

      expect(@event.field_values.find_by(field_code: 'latitude').value).to eq(@province.latitude.to_s)
      expect(@event.field_values.find_by(field_code: 'longitude').value).to eq(@province.longitude.to_s)
    end

    it 'should set district geo point on update' do
      field = @root_milestone.fields.find_by(code: 'district_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @district.code)
      @event.save

      expect(@event.field_values.find_by(field_code: 'latitude').value).to eq(@district.latitude.to_s)
      expect(@event.field_values.find_by(field_code: 'longitude').value).to eq(@district.longitude.to_s)
    end

    it 'should set commune geo point on update' do
      field = @root_milestone.fields.find_by(code: 'commune_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @commune.code)
      @event.save

      expect(@event.field_values.find_by(field_code: 'latitude').value).to eq(@commune.latitude.to_s)
      expect(@event.field_values.find_by(field_code: 'longitude').value).to eq(@commune.longitude.to_s)
    end

    it 'should set village geo point on update' do
      field = @root_milestone.fields.find_by(code: 'village_id')
      @event.field_values.create(field_id: field.id, field_code: field.code, value: @village.code)
      @event.save

      expect(@event.field_values.find_by(field_code: 'latitude').value).to eq(@village.latitude.to_s)
      expect(@event.field_values.find_by(field_code: 'longitude').value).to eq(@village.longitude.to_s)
    end
  end
end
