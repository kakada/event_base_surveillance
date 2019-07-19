require 'rails_helper'

RSpec.describe Field, type: :model do
  it { is_expected.to have_many(:form_fields) }
  it { is_expected.to have_many(:forms).through(:form_fields) }
  it { is_expected.to validate_presence_of(:name) }
end
