require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to(:parent).class_name('Location').optional }
  it { is_expected.to have_many(:children).class_name('Location') }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:kind) }

  describe 'validate geopoint' do
    location = FactoryBot.build :location

    it 'is invalid with latitude less than -90' do
      location.geopoint = '-90.1,1'
      location.valid?
      expect(location.errors[:geopoint]).to match_array "is invalid"
    end

    it 'is invalid with latitude greater than 90' do
      location.geopoint = '90.1,0'
      location.valid?
      expect(location.errors[:geopoint]).to match_array "is invalid"
    end

    it 'is invalid with longitude less than -180' do
      location.geopoint = '1,-180.1'
      location.valid?
      expect(location.errors[:geopoint]).to match_array "is invalid"
    end

    it 'is invalid with longitude greater than 180' do
      location.geopoint = '1,180.1'
      location.valid?
      expect(location.errors[:geopoint]).to match_array "is invalid"
    end
  end
end
