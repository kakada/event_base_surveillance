require 'rails_helper'

RSpec.describe Events::TraceableField do
  describe 'before_create #build_tracing' do
    let!(:program) { create(:program) }
    let!(:milestone) { program.milestones.root }
    let(:event) { create(:event, program: program) }
    let(:number_of_case) { event.field_values.where(field_code: 'number_of_case').first }
    let(:number_of_death) { event.field_values.where(field_code: 'number_of_death').first }
    let(:description) { event.field_values.where(field_code: 'description').first }
    let(:description_field) { milestone.fields.where(code: 'description').first }
    let(:risk_level) { event.field_values.where(field_code: 'risk_level').first }
    let(:risk_level_field) { milestone.fields.where(code: 'risk_level').first }

    before :each do
      milestone.fields.where(code: ['number_of_case', 'number_of_death', 'description', 'risk_level']).update_all(tracking: true)
    end

    context 'number field' do
      it { expect(event.tracings.length).to eq(1) }
      it { expect(event.tracings.first.type).to eq('Tracings::NumberTracing') }
      it { expect(event.tracings.first.properties).to eq({'number_of_case' => number_of_case.value, 'number_of_death' => number_of_death.try(:value) || 0 }) }
    end

    context 'text field' do
      before :each do
        event.update_attributes(
          field_values_attributes: [
            { field_id: description_field.id, field_code: description_field.code, value: 'Dummy text' },
            { field_id: risk_level_field.id, field_code: risk_level_field.code, value: 'Low' }
          ]
        )
      end

      it { expect(event.tracings.length).to eq(3) }
      it { expect(event.tracings[1].type).to eq('Tracings::TextTracing') }
      it { expect(event.tracings[1].field_id).to eq(description.field_id) }
      it { expect(event.tracings[1].field_value).to eq(description.value) }
      it { expect(event.tracings.last.type).to eq('Tracings::TextTracing') }
      it { expect(event.tracings.last.field_id).to eq(risk_level.field_id) }
      it { expect(event.tracings.last.field_value).to eq(risk_level.value) }
    end
  end
end
