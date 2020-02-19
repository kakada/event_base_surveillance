# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to have_one(:message) }
  it { is_expected.to have_one(:telegram).class_name('Notifications::Telegram') }
  it { is_expected.to have_many(:sections).dependent(:destroy) }
  it { is_expected.to have_many(:fields).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'validation' do
    let!(:program) { create(:program) }
    let!(:milestone1) { create(:milestone, program: program, final: true) }
    let!(:milestone2) { build(:milestone, program: program, final: true) }

    it '#only_one_final_milestone' do
      milestone2.save
      expect(milestone2.errors).to include(:final)
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
