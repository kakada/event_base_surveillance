# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to have_one(:message) }
  it { is_expected.to have_one(:telegram_notification).class_name('Notifications::TelegramNotification') }
  it { is_expected.to have_many(:sections).dependent(:destroy) }
  it { is_expected.to have_many(:fields).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'validation' do
    let!(:program) { create(:program) }

    context 'only_one_final_milestone' do
      let!(:milestone1) { create(:milestone, program: program, status: :final) }
      let!(:milestone2) { build(:milestone, program: program, status: :final) }

      it 'raises error include final' do
        milestone2.save
        expect(milestone2.errors).to include(:status)
      end
    end

    context 'only_one_verified_milestone' do
      let!(:milestone1) { create(:milestone, program: program, status: :verified) }
      let!(:milestone2) { build(:milestone, program: program, status: :verified) }

      it 'raises error include verified' do
        milestone2.save
        expect(milestone2.errors).to include(:status)
      end
    end
  end

  describe '#update_order' do
    let!(:program) { create(:program) }
    let!(:milestone1) { program.milestones.root }
    let!(:milestone2) { create(:milestone, program: program, display_order: 2) }
    let!(:milestone3) { create(:milestone, program: program, display_order: 3) }

    before :each do
      program.milestones.update_order!([milestone3.id, milestone2.id, milestone1.id])
    end

    it { expect(milestone3.reload.display_order).to eq(1) }
    it { expect(milestone2.reload.display_order).to eq(2) }
    it { expect(milestone1.reload.display_order).to eq(3) }
  end
end
