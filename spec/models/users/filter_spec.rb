# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_telegram' do
    context 'phone_or_email is nil or province_code_or_name is nil' do
      it { expect(User.from_telegram(nil, nil)).to be_nil }
    end

    context 'provincal user' do
      let!(:province) { create(:location, code: '01') }
      let!(:user) { create(:user, :staff, province_code: '01', phone_number: '011222333' ) }

      context 'wrong info' do
        it { expect(User.from_telegram(user.email, '02')).to be_nil }
        it { expect(User.from_telegram(user.phone_number, '02')).to be_nil }
      end

      context 'right info' do
        it { expect(User.from_telegram(user.email, '01')).not_to be_nil }
        it { expect(User.from_telegram(user.email, 'Banteay Meanchey')).not_to be_nil }
        it { expect(User.from_telegram(user.email, 'បន្ទាយមានជ័យ')).not_to be_nil }
        it { expect(User.from_telegram(user.phone_number, '01')).not_to be_nil }
        it { expect(User.from_telegram(user.phone_number, 'Banteay Meanchey')).not_to be_nil }
        it { expect(User.from_telegram(user.phone_number, 'បន្ទាយមានជ័យ')).not_to be_nil }
      end
    end

    context 'national user' do
      let!(:program_admin) { create(:user, :program_admin, phone_number: '011234567') }
      let!(:national_staff) { create(:user, :national_staff, phone_number: '010222333') }

      context 'wrong info' do
        it { expect(User.from_telegram(program_admin.email, '01')).to be_nil }
      end

      context 'right info' do
        it { expect(User.from_telegram(program_admin.email, 'national')).not_to be_nil }
        it { expect(User.from_telegram(program_admin.phone_number, 'National')).not_to be_nil }
        it { expect(User.from_telegram(national_staff.email, 'ថ្នាក់ជាតិ')).not_to be_nil }
        it { expect(User.from_telegram(national_staff.phone_number, 'គ្រប់ខេត្ត/ក្រុង')).not_to be_nil }
      end
    end
  end
end
