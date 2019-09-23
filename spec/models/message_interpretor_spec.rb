require 'rails_helper'

RSpec.describe MessageInterpretor, type: :model do
  describe '#message' do
    context 'milestone new and create new event' do
      let(:template) { "Hi all! There is {{de_event_type_name}} happen in {{de_location}}, so please consider it. The source is from {{dy_1_source_of_information}}" }
      let(:event) { create(:event) }
      let(:interpretor) { MessageInterpretor.new(template, event.uuid) }

      it { expect(interpretor.message).to eq("Hi all! There is #{event.event_type_name} happen in #{event.location}, so please consider it. The source is from ") }
    end

    context 'milestone risk_assessment and create event milestone' do
      let(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values) }
      let(:male) { event_milestone.milestone.fields.find_by(name: '# of Male') }
      let(:female) { event_milestone.milestone.fields.find_by(name: '# of Female') }
      let(:template) { "It's risk level is {{de_risk_level}}, and it was conducted the assessment at {{emde_conducted_at}}, so there are {{emdy_#{female.id}_#_of_female}} women die, and {{emdy_#{male.id}_#_of_male}} men die." }
      let(:interpretor) { MessageInterpretor.new(template, event_milestone.event.uuid, event_milestone.id) }

      it { expect(interpretor.message).to eq("It's risk level is High, and it was conducted the assessment at #{Date.today}, so there are 2 women die, and 3 men die.") }
    end
  end
end
