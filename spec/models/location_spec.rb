# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to(:parent).class_name('Location').optional }
  it { is_expected.to have_many(:children).class_name('Location') }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:kind) }
  it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
  it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }

  describe 'presence_of_lat_lng' do
    location = FactoryBot.build :location

    it 'should valid when latitude and longitude are assigned' do
      location.latitude = 1.5
      location.longitude = 1.5
      expect(location).to be_valid
    end

    it 'should valid when latitude and longitude are not assigned' do
      location.latitude = nil
      location.longitude = nil
      expect(location).to be_valid
    end

    it 'should validate raise error when longitude has no value' do
      location.longitude = nil
      location.latitude = 1.5
      location.valid?
      expect(location.errors[:longitude]).to match_array "can't be blank"
    end

    it 'should validate raise error when longitude has no value' do
      location.longitude = 1.5
      location.latitude = nil
      location.valid?
      expect(location.errors[:latitude]).to match_array "can't be blank"
    end
  end

  describe '.pumi_provinces' do
    context 'no province_code' do
      let(:user) { create(:user, province_code: nil) }

      it { expect(Location.pumi_provinces(user).size).to eq(Pumi::Province.all.size) }
    end

    context 'province_code is all' do
      let(:user) { create(:user, province_code: 'all') }

      it { expect(Location.pumi_provinces(user).size).to eq(Pumi::Province.all.size) }
    end

    context 'province_code is a code' do
      let(:user) { create(:user, province_code: '01') }

      it { expect(Location.pumi_provinces(user).size).to eq(1) }
    end
  end
end
