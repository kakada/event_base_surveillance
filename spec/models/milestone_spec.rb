require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to have_one(:telegram).class_name('Notifications::Telegram') }
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
end
