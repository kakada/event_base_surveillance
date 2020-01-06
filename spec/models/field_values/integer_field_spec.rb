require 'rails_helper'

RSpec.describe FieldValues::DateField do
  describe '#valid_value?' do
    let(:fv) { create(:field_value, :integer) }
    let(:field_value) { fv.type.constantize.new(fv.attributes) }

    it { expect(field_value.valid_value?).to be_truthy }

    it 'is invalid' do
      field_value.value = 'invalid number'
      expect(field_value.valid_value?).to be_falsey
    end
  end

  describe '#valid_condition?' do
    let(:event) { create(:event) }
    let(:fv) { create(:field_value, :integer, valueable_id: event.id) }
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
        field.update_attributes(validations: { from: '5', to: '' })
      end

      it 'is valid' do
        field_value.value = '6'

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is invalid' do
        field_value.value = '4'

        expect(field_value.valid_condition?).to be_falsey
      end
    end

    context 'has only to validations' do
      before :each do
        field.update_attributes(validations: { from: '', to: 5 })
      end

      it 'is valid' do
        field_value.value = '4'

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is invalid' do
        field_value.value = '6'

        expect(field_value.valid_condition?).to be_falsey
      end
    end

    context 'has both from and to validations' do
      before :each do
        field.update_attributes(validations: { from: '5', to: '6' })
      end

      it 'is valid' do
        field_value.value = '5'

        expect(field_value.valid_condition?).to be_truthy
      end

      it 'is return false' do
        field_value.value = '4'

        expect(field_value.valid_condition?).to be_falsey
      end

      it 'is invalid' do
        field_value.value = '7'

        expect(field_value.valid_condition?).to be_falsey
      end
    end
  end
end
