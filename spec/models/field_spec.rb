require 'rails_helper'

RSpec.describe Field, type: :model do
  it { is_expected.to belong_to(:form_type) }
  it { is_expected.to have_many(:field_options) }
  it { is_expected.to validate_presence_of(:name) }
end
