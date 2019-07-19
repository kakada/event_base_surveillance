require 'rails_helper'

RSpec.describe FormFieldValue, type: :model do
  it { is_expected.to belong_to(:form_field) }
  it { is_expected.to belong_to(:event) }
end
