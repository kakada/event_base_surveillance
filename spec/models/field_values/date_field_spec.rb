# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldValues::DateField do
  describe '#valid_value?' do
    let(:fv) { create(:field_value, :date) }
    let(:field_value) { fv.type.constantize.new(fv.attributes) }

    it { expect(field_value.valid_value?).to be_truthy }

    context 'blank value' do
      it 'is valid' do
        field_value.value = ''
        expect(field_value.valid_value?).to be_truthy
      end
    end

    it 'is invalid' do
      field_value.value = 'invalid date'
      expect(field_value.valid_value?).to be_falsey
    end
  end

  describe '#valid_condition?' do
    let(:event) { create(:event) }
    let(:fv) { create(:field_value, :date, valueable_id: event.id) }
    let(:field_value) { fv.type.constantize.new(fv.attributes) }
    let(:field) { field_value.field }

    context 'no validations' do
      before :each do
        field_value.field.validations = {}
      end

      it { expect(field_value.valid_condition?).to be_truthy }
    end

    context 'validations from and to is blank' do
      before :each do
        field.update_attributes(validations: { from: '', to: '' })
      end

      it { expect(field_value.valid_condition?).to be_truthy }
    end

    context 'has only from validations' do
      before :each do
        field.update_attributes(validations: { from: Date.today.to_s, to: '' })
      end

      it 'is valid' do
        field_value.value = Date.today.to_s

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is invalid' do
        field_value.value = Date.yesterday.to_s

        expect(field_value.valid_condition?).to be_falsey
      end
    end

    context 'has only to validations' do
      before :each do
        field.update_attributes(validations: { from: '', to: Date.today.to_s })
      end

      it 'is valid' do
        field_value.value = Date.today.to_s

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is invalid' do
        field_value.value = Date.tomorrow.to_s

        expect(field_value.valid_condition?).to be_falsey
      end
    end

    context 'has both from and to validations' do
      before :each do
        field.update_attributes(validations: { from: Date.today.to_s, to: Date.tomorrow.to_s })
      end

      it 'is valid' do
        field_value.value = Date.today.to_s

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is return false' do
        field_value.value = Date.yesterday.to_s

        expect(field_value.valid_condition?).to be_falsey
      end

      it 'is invalid' do
        field_value.value = (Date.tomorrow + 1).to_s

        expect(field_value.valid_condition?).to be_falsey
      end
    end
  end
end
