require 'rails_helper'

RSpec.describe FormField, type: :model do
  it { is_expected.to belong_to(:form) }
  it { is_expected.to belong_to(:field) }
  it { is_expected.to have_many(:form_field_values) }
end
