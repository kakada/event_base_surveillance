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

  describe 'unlock?' do
    subject { described_class }
    let!(:program_admin) { create(:user) }
    let!(:staff) { create(:user, :staff) }
    let!(:closed_event) { create(:event, close: true, lockable_at: nil) }

    permissions :unlock? do
      it { expect(subject).to permit(program_admin, closed_event) }
      it { expect(subject).not_to permit(staff, closed_event) }
    end
  end

  describe 'permissions show?' do
    subject { described_class }

    let(:program_1) { create(:program, name: 'abc') }
    let(:program_2) { create(:program, name: 'def') }

    let(:event1) { build(:event, program: program_1) }
    let(:event2) { build(:event, program: program_2) }
    let(:event_type) { build(:event_type, shared: true) }
    let(:event_share) { build(:event, program: program_2, location_code: '010101', event_type: event_type) }

    permissions :show? do
      context 'system_admin' do
        let(:system_admin) { build(:user, :system_admin) }

        it 'grants access if event created in program1' do
          expect(subject).to permit(system_admin, event1)
        end

        it 'grants access if event created in program2' do
          expect(subject).to permit(system_admin, event2)
        end

        it 'grants access if shared event' do
          expect(subject).to permit(system_admin, event_share)
        end
      end

      context 'program_admin1' do
        let(:program_admin1) { build(:user, :program_admin, program: program_1) }

        it 'grants access if event created in program1' do
          expect(subject).to permit(program_admin1, event1)
        end

        it 'denies access if event created in program2' do
          expect(subject).not_to permit(program_admin1, event2)
        end

        it 'grants access if shared event' do
          expect(subject).to permit(program_admin1, event_share)
        end
      end

      context 'national_staff' do
        let(:national_staff) { build(:user, :national_staff, program: program_1) }
        let(:shared_event2) { }

        it 'grants access if event created in program1' do
          expect(subject).to permit(national_staff, event1)
        end

        it 'denies access if event created in program2' do
          expect(subject).not_to permit(national_staff, event2)
        end

        it 'grants access if shared event' do
          expect(subject).to permit(national_staff, event_share)
        end
      end

      context 'province_staff' do
        let(:event1) { build(:event, program: program_1, location_code: '010101') }
        let(:staff) { build(:user, :staff, program: program_1, province_code: '01') }
        let(:event_share2) { build(:event, program: program_2, location_code: '020101',  event_type: event_type) }

        it 'grants access if event created in program1' do
          expect(subject).to permit(staff, event1)
        end

        it 'denies access if event created in program2' do
          expect(subject).not_to permit(staff, event2)
        end

        it 'grants access if shared event under user province' do
          expect(subject).to permit(staff, event_share)
        end

        it 'denies access if shared event under different from user province' do
          expect(subject).not_to permit(staff, event_share2)
        end
      end
    end
  end
end
