require 'rails_helper'

RSpec.describe FieldValue, type: :model do
  it { is_expected.to belong_to(:field) }
  it { is_expected.to belong_to(:valueable) }
end
