# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to belong_to(:conclude_event_type).class_name('EventType').optional }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name('User').optional }
  it { is_expected.to belong_to(:location).with_foreign_key('location_code').optional }
  it { is_expected.to have_many(:event_milestones) }
  it { is_expected.to have_many(:field_values) }
  it { is_expected.to have_many(:tracings) }
  it { is_expected.to validate_presence_of(:event_type_id) }

  describe 'before_validation: #set_location and #assign_nil_locations' do
    let!(:province) { create(:location) }
    let!(:district) { create(:location, code: '0102', kind: 'district') }
    let!(:commune)  { create(:location, code: '010201', kind: 'commune') }
    let!(:village)  { create(:location, code: '01020101', kind: 'village') }
    let!(:event)    { create(:event) }
    let!(:root_fields) { event.milestone.fields }

    context 'province' do
      it { expect(event.location_code).to eq(province.code) }
    end

    context 'district' do
      before { create_field_value(event, 'district_id', district.code) }

      it { expect(event.location_code).to eq(district.code) }
    end

    context 'commune' do
      before do
        create_field_value(event, 'district_id', district.code)
        create_field_value(event, 'commune_id', commune.code)
      end

      it { expect(event.location_code).to eq(commune.code) }
    end

    context 'village' do
      before do
        create_field_value(event, 'district_id', district.code)
        create_field_value(event, 'commune_id', commune.code)
        create_field_value(event, 'village_id', village.code)
      end

      it { expect(event.location_code).to eq(village.code) }
    end

    context 'district nil' do
      before do
        create_field_value(event, 'commune_id', commune.code)
        create_field_value(event, 'village_id', village.code)
        create_field_value(event, 'district_id', nil)
      end

      it { expect(event.location_code).to eq(province.code) }
      it { expect(get_fv(event, 'commune_id').value).to be_nil }
      it { expect(get_fv(event, 'village_id').value).to be_nil }
    end

    context 'commune nil' do
      before do
        create_field_value(event, 'district_id', district.code)
        create_field_value(event, 'village_id', village.code)
        create_field_value(event, 'commune_id', nil)
      end

      it { expect(event.location_code).to eq(district.code) }
      it { expect(get_fv(event, 'village_id').value).to be_nil }
    end

    context 'village nil' do
      before do
        create_field_value(event, 'district_id', district.code)
        create_field_value(event, 'commune_id', commune.code)
        create_field_value(event, 'village_id', nil)
      end

      it { expect(event.location_code).to eq(commune.code) }
    end
  end

  describe '#secure_uuid' do
    let!(:uuid) { SecureRandom.hex(4) }
    let!(:event1) { create(:event, uuid: uuid) }
    let!(:event2) { create(:event, uuid: uuid) }

    it { expect(event2.uuid).not_to eq(uuid) }
  end

  describe '#location_name' do
    let!(:event) { create(:event) }

    it { expect(event.location_name).to eq('ខេត្តបន្ទាយមានជ័យ') }
    it { expect(event.location_name('address_latin')).to eq('Khaet Banteay Meanchey') }
  end

  describe '#unlockable?' do
    let!(:event1) { create(:event, close: true, lockable_at: nil) }
    let!(:event2) { create(:event, close: true, lockable_at: Date.today) }

    it { expect(event1.unlockable?).to eq(true) }
    it { expect(event2.unlockable?).to eq(false) }
  end

  private
    def create_field_value(event, code, value)
      root_fields = event.milestone.fields
      event.field_values.build(field_id: root_fields.find_by(code: code).id, field_code: code, value: value)
      event.save
    end

    def get_fv(event, code)
      event.field_values.find_by(field_code: code)
    end
end
