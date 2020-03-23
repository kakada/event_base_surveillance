require 'rails_helper'

RSpec.describe Template, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:template_fields) }
  it { is_expected.to have_many(:fields).through(:template_fields) }
end
