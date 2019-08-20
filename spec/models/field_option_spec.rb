require 'rails_helper'

RSpec.describe FieldOption, type: :model do
  it { is_expected.to belong_to(:field) }
end
