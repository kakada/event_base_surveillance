require 'rails_helper'

RSpec.describe Field, type: :model do
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to have_many(:field_options).dependent(:destroy) }
  it { is_expected.to have_many(:field_values).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:field_type) }
  it { is_expected.to validate_inclusion_of(:field_type).in_array(Field::FIELD_TYPES) }
end
