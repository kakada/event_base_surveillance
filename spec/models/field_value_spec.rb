# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldValue, type: :model do
  it { is_expected.to belong_to(:field) }
  it { is_expected.to belong_to(:valueable) }

  describe 'after_save #assign_event_date' do
    let!(:event) { create(:event) }

    it { expect(event.field_values.find_by(field_code: 'event_date').es_value).to eq(event.event_date) }
  end
end
