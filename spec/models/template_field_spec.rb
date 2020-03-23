require 'rails_helper'

RSpec.describe TemplateField, type: :model do
  it { is_expected.to belong_to(:field) }
  it { is_expected.to belong_to(:template) }
end
