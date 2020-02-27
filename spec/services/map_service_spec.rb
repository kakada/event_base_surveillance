# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapService do
  describe 'get_event_data' do
    let!(:admin_a) { create(:user) }
    let!(:admin_b) { create(:user) }

    let!(:program_a) { admin_a.program }
    let!(:program_b) { admin_b.program }

    let!(:influenza_a)   { create(:event_type, program: program_a) }
    let!(:h5n1_a_shared) { create(:event_type, shared: true, program: program_a) }

    let!(:pes_jruk_b)    { create(:event_type, program: program_b) }
    let!(:h1n1_b_shared) { create(:event_type, shared: true, program: program_b) }

    let!(:event_influenza_a)   { create(:event, event_type: influenza_a, program: program_a) }
    let!(:event_h5n1_a_shared) { create(:event, event_type: h5n1_a_shared, program: program_a) }

    let!(:event_pes_jruk_b)    { create(:event, event_type: pes_jruk_b, program: program_b) }
    let!(:event_pes_jruk2_b)   { create(:event, event_type: pes_jruk_b, program: program_b) }
    let!(:event_h1n1_b_shared) { create(:event, event_type: h1n1_b_shared, program: program_b) }

    context 'admin_a' do
      let!(:data) { MapService.new(admin_a).get_event_data }
      let!(:influenza_a_fv) { data.select { |d| d[:event_type_id] == influenza_a.id }.first }
      let!(:h5n1_a_shared_fv) { data.select { |d| d[:event_type_id] == h5n1_a_shared.id }.first }
      let!(:h1n1_b_shared_fv) { data.select { |d| d[:event_type_id] == h1n1_b_shared.id }.first }

      it { expect(data.length).to eq(3) }

      it { expect(data.pluck(:event_type_id)).to include(influenza_a.id) }
      it { expect(data.pluck(:event_type_id)).to include(h5n1_a_shared.id) }
      it { expect(data.pluck(:event_type_id)).to include(h1n1_b_shared.id) }

      it { expect(influenza_a_fv[:total_count]).to eq(1) }
      it { expect(h5n1_a_shared_fv[:total_count]).to eq(1) }
      it { expect(h1n1_b_shared_fv[:total_count]).to eq(1) }

      it { expect(influenza_a_fv[:number_of_case]).to eq(event_influenza_a.field_values.find_by(field_code: 'number_of_case').value) }
      it { expect(h5n1_a_shared_fv[:number_of_case]).to eq(event_h5n1_a_shared.field_values.find_by(field_code: 'number_of_case').value) }
      it { expect(h1n1_b_shared_fv[:number_of_case]).to eq(event_h1n1_b_shared.field_values.find_by(field_code: 'number_of_case').value) }
    end

    context 'admin_b' do
      let!(:data) { MapService.new(admin_b).get_event_data }
      let!(:pes_jruk_b_fv) { data.select { |d| d[:event_type_id] == pes_jruk_b.id }.first }
      let!(:h1n1_b_shared_fv) { data.select { |d| d[:event_type_id] == h1n1_b_shared.id }.first }
      let!(:h5n1_a_shared_fv) { data.select { |d| d[:event_type_id] == h5n1_a_shared.id }.first }
      let!(:number_of_case_event_pes_jruk) { event_pes_jruk_b.field_values.find_by(field_code: 'number_of_case').value.to_i + event_pes_jruk2_b.field_values.find_by(field_code: 'number_of_case').value.to_i }

      it { expect(data.length).to eq(3) }

      it { expect(data.pluck(:event_type_id)).to include(pes_jruk_b.id) }
      it { expect(data.pluck(:event_type_id)).to include(h1n1_b_shared.id) }
      it { expect(data.pluck(:event_type_id)).to include(h5n1_a_shared.id) }

      it { expect(pes_jruk_b_fv[:total_count]).to eq(2) }
      it { expect(h5n1_a_shared_fv[:total_count]).to eq(1) }
      it { expect(h1n1_b_shared_fv[:total_count]).to eq(1) }

      it { expect(pes_jruk_b_fv[:number_of_case]).to eq(number_of_case_event_pes_jruk.to_s) }
      it { expect(h5n1_a_shared_fv[:number_of_case]).to eq(event_h5n1_a_shared.field_values.find_by(field_code: 'number_of_case').value) }
      it { expect(h1n1_b_shared_fv[:number_of_case]).to eq(event_h1n1_b_shared.field_values.find_by(field_code: 'number_of_case').value) }
    end
  end
end
