require 'rails_helper'

RSpec.describe Form, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:form_type) }
  it { is_expected.to belong_to(:submitter).class_name('User').optional }
  it { is_expected.to validate_presence_of(:conducted_at) }
end
