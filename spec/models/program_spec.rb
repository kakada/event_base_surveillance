# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Program, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:client_apps) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:event_types) }
  it { is_expected.to have_many(:milestones) }
  it { is_expected.to have_many(:webhooks) }
  it { is_expected.to have_many(:templates) }

  describe '#after create' do
    let!(:program) { create(:program) }

    it { expect(program.milestones.root).not_to be_nil }
    it { expect(program.event_types.root).not_to be_nil }
    it { expect { create(:program) }.to change(ProgramWorker.jobs, :size).by(1) }
  end

  describe '#format_name' do
    let(:program) { create(:program, name: 'ABC Program') }

    it { expect(program.format_name).to eq('abc_program') }
  end
end
