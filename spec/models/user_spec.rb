require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to define_enum_for(:role).with_values(system_admin: 1, program_admin: 2, staff: 3) }
end
