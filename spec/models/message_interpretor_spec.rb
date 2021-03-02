# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageInterpretor, type: :model do
  describe '#message' do
    context 'milestone new and create new event' do
      let!(:event) { create(:event) }
      let!(:source_field) { event.milestone.fields.create({ name: 'Source of information', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Hotline' }, { name: 'RRT' }] }) }
      let!(:template) { "Hi all! There is {{de_event_type_name}} happen in {{de_location_name}}, so please consider it. The source is from {{dy_#{source_field.id}_source_of_information}}" }
      let!(:interpretor) { MessageInterpretor.new(template, event.uuid) }

      it { expect(interpretor.message).to eq("Hi all! There is <b>#{event.event_type_name}</b> happen in <b>#{event.location_name}</b>, so please consider it. The source is from <b></b>") }
    end

    context 'milestone risk_assessment and create event milestone' do
      let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values) }
      let!(:male) { event_milestone.milestone.fields.find_by(name: '# of Male') }
      let!(:female) { event_milestone.milestone.fields.find_by(name: '# of Female') }
      let!(:conducted_at) { event_milestone.milestone.fields.find_by(code: 'conducted_at') }
      let!(:risk_level) { event_milestone.program.milestones.root.fields.find_by(code: 'risk_level') }
      let!(:template) { "It's risk level is {{dy_#{risk_level.id}_risk_level}}, and it was conducted the assessment at {{emdy_#{conducted_at.id}_conducted_at}}, so there are {{emdy_#{female.id}_#_of_female}} women die, and {{emdy_#{male.id}_#_of_male}} men die." }
      let!(:interpretor) { MessageInterpretor.new(template, event_milestone.event.uuid, event_milestone.id) }
      let!(:risk_assessment_conducted_on) { event_milestone.field_values.find_by field_code: 'conducted_at' }

      it { expect(interpretor.message).to eq("It's risk level is <b>high</b>, and it was conducted the assessment at <b>#{risk_assessment_conducted_on.value}</b>, so there are <b>2</b> women die, and <b>3</b> men die.") }
    end
  end
end
