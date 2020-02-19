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
end
