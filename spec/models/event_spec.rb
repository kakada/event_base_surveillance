require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type).optional }
  it { is_expected.to belong_to(:creator).class_name('User').optional }
  it { is_expected.to have_many(:event_milestones).dependent(:destroy) }
  it { is_expected.to have_many(:field_values) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:event_date) }
  it { is_expected.to validate_presence_of(:report_date) }
  it { is_expected.to validate_presence_of(:province_id) }

  describe 'set_geo_point' do
    before :all do
      @province = FactoryBot.create :location
      @district = FactoryBot.create :location, code: '0102', latitude: 0.1, longitude: 0.5
      @commune = FactoryBot.create :location, code: '010201', latitude: 0.13, longitude: 0.51
      @village = FactoryBot.create :location, code: '01020101', latitude: 0.132, longitude: 0.512

      @event = FactoryBot.create :event
    end

    it 'should set province geo point on create' do
      expect(@event.latitude).to eq(@province.latitude)
      expect(@event.longitude).to eq(@province.longitude)
    end

    it 'should set district geo point on update' do
      @event.district_id = '0102'
      @event.save
      expect(@event.latitude).to eq(@district.latitude)
      expect(@event.longitude).to eq(@district.longitude)
    end

    it 'should set commune geo point on update' do
      @event.commune_id = '010201'
      @event.save
      expect(@event.latitude).to eq(@commune.latitude)
      expect(@event.longitude).to eq(@commune.longitude)
    end

    it 'should set village geo point on update' do
      @event.village_id = '01020101'
      @event.save
      expect(@event.latitude).to eq(@village.latitude)
      expect(@event.longitude).to eq(@village.longitude)
    end
  end
end
