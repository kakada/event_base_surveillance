# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventPolicy do
  describe 'scope' do
    let!(:program) { create(:program) }
    let!(:province1) { create(:location) }
    let!(:province2) { create(:location, code: '02', name_km: 'បាត់ដំបង', name_en: 'Battambang') }
    let!(:event1) { create(:event, location: province1, program: program) }
    let!(:event2) { create(:event, location: province2, program: program) }

    context 'system_admin' do
      let!(:system_admin) { create(:user, :system_admin, province_code: province2.code) }

      it { expect(Pundit.policy_scope!(system_admin, Event).size).to eq(2) }
    end

    context 'program_admin' do
      let!(:program_admin) { create(:user, province_code: province2.code, program: program) }

      it { expect(Pundit.policy_scope!(program_admin, Event).size).to eq(2) }
    end

    context 'staff' do
      let!(:staff) { create(:user, :staff, province_code: province1.code, program: program) }

      it { expect(Pundit.policy_scope!(staff, Event).size).to eq(1) }
      it { expect(Pundit.policy_scope!(staff, Event).first).to eq(event1) }
    end

    context 'guest' do
      let!(:guest) { create(:user, :guest, province_code: province2.code, program: program) }

      it { expect(Pundit.policy_scope!(guest, Event).size).to eq(1) }
      it { expect(Pundit.policy_scope!(guest, Event).first).to eq(event2) }
    end

    context 'with all province_code' do
      let!(:guest) { create(:user, :guest, province_code: 'all', program: program) }

      it { expect(Pundit.policy_scope!(guest, Event).size).to eq(2) }
    end
  end
end
