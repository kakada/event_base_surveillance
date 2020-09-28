# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldValues::SelectOneField do
  describe '#es_value' do
    context 'field exist' do
      let(:field_value) { create(:field_value_select_one, :with_hotline_option, value: 'hotline') }

      it { expect(field_value.es_value).to eq('Hotline') }
    end

    context 'field not exist' do
      let(:field_value) { create(:field_value_select_one, :with_hotline_option, value: 'hotline') }

      before {
        field_value.field.destroy
      }

      it { expect(field_value.reload.es_value).to eq('hotline') }
    end

    context 'field no option' do
      let(:field_value) { create(:field_value_select_one, :with_hotline_option, value: 'phone_call') }

      it { expect(field_value.es_value).to eq('phone_call') }
    end
  end
end
