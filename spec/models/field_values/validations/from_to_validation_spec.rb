# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldValues::FromToValidation do
  let!(:fv)     { create(:field_value, :date) }
  let!(:event)  { fv.valueable }
  let(:field_value) { fv.type.constantize.new(fv.attributes) }

  describe 'validate condition from, to' do
    context 'no condition from to' do
      before {
        allow(field_value.field).to receive(:validations).and_return({})
      }

      it { expect(field_value.valid?).to be_truthy }
    end

    context 'both from and to conditions are blank' do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: '', to: '' })
      }

      it { expect(field_value.valid?).to be_truthy }
    end

    context 'only from condition exist' do
      before {
        allow(field_value).to receive(:validations).and_return({ from: Date.today.to_s, to: '' })
      }

      context 'valid' do
        before {
          field_value.value = Date.today.to_s
        }

        it { expect(field_value.valid?).to be_truthy }
      end

      context 'invalid' do
        before {
          field_value.value = Date.yesterday.to_s
          field_value.valid?
        }

        it { expect(field_value.valid?).to be_falsey }
        it { expect(field_value.errors[:value]).to eq [I18n.t('shared.must_be_from', from: field_value.validations[:from])] }
      end
    end

    context 'only to condition exist' do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: '', to: Date.today.to_s })
      }

      context 'valid' do
        before {
          field_value.value = Date.today.to_s
        }

        it { expect(field_value.valid?).to be_truthy }
      end

      context 'invalid' do
        before {
          field_value.value = Date.tomorrow.to_s
          field_value.valid?
        }

        it { expect(field_value.valid?).to be_falsey }
        it { expect(field_value.errors[:value]).to eq [I18n.t('shared.must_not_over', to: field_value.validations[:to])] }
      end
    end

    context 'both from and to condition exist' do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: Date.today.to_s, to: Date.tomorrow.to_s })
      }

      context 'valid' do
        before {
          field_value.value = Date.today.to_s
        }

        it { expect(field_value.valid?).to be_truthy }
      end

      context 'smaller than from' do
        before {
          field_value.value = Date.yesterday.to_s
          field_value.valid?
        }

        it { expect(field_value.valid?).to be_falsey }
        it { expect(field_value.errors[:value]).to eq [I18n.t('shared.must_be_from_to', from: field_value.validations[:from], to: field_value.validations[:to])] }
      end

      context 'bigger than to' do
        before {
          field_value.value = (Date.tomorrow + 1).to_s
          field_value.valid?
        }

        it { expect(field_value.valid?).to be_falsey }
        it { expect(field_value.errors[:value]).to eq [I18n.t('shared.must_be_from_to', from: field_value.validations[:from], to: field_value.validations[:to])] }
      end
    end
  end
end
