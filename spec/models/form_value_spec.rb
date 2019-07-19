require 'rails_helper'

RSpec.describe FormValue, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:form) }
  it { is_expected.to belong_to(:submitter).class_name('User') }
end
