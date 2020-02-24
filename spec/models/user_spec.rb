# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:program).optional }
  it { is_expected.to have_many(:event_types) }
  it { is_expected.to have_many(:events).with_foreign_key(:creator_id) }
  it { is_expected.to have_many(:programs).with_foreign_key(:creator_id) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to define_enum_for(:role).with_values(system_admin: 1, program_admin: 2, staff: 3, guest: 4) }

  describe 'validation' do
    let(:system_admin) { build(:user, :system_admin, program_id: nil) }
    let(:program_admin) { build(:user, program_id: nil) }

    it { expect(system_admin.save).to be_truthy }
    it { expect(program_admin.save).to be_falsey }
  end

  describe 'presence of province_code' do
    context 'staff and guest' do
      let(:staff1) { build(:user, :staff, province_code: nil) }
      let(:staff2) { build(:user, :staff, province_code: '01') }
      let(:guest1) { build(:user, :staff, province_code: nil) }
      let(:guest2) { build(:user, :staff, province_code: '01') }

      it { expect(staff1.save).to be_falsey }
      it { expect(staff2.save).to be_truthy }
      it { expect(guest1.save).to be_falsey }
      it { expect(guest2.save).to be_truthy }
    end
  end

  describe 'location' do
    context 'db location exist' do
      let(:province) { create(:location) }
      let(:user)  { create(:user, province_code: province.id) }

      it { expect(user.location.class.name).to eq('Location') }
      it { expect(user.location.kind).to eq('province') }
    end

    context 'db location does not exist' do
      let(:user)  { create(:user, province_code: '02') }

      it { expect(user.location.class.name).to eq('Pumi::Province') }
      it { expect(user.location.name_en).to eq('Battambang') }
    end
  end
end
