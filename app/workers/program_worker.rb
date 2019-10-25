# frozen_string_literal: true

class ProgramWorker
  include Sidekiq::Worker

  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL']

  def perform(program_id)
    program = Program.find_by(id: program_id)
    return if program.nil?

    # events_gdaph
    create_indice("#{Event.index_name}_#{program.format_name}", program)
    create_shared_indices(program)
  end

  private

  def create_shared_indices(program)
    Program.where.not(id: program.id).each do |target_program|
      # gdaph_p#{cdc.id}_shared
      create_indice("#{program.format_name}_p#{target_program.id}_shared", target_program)
      # cdc_p#{gdaph.id}_shared
      create_indice("#{target_program.format_name}_p#{program.id}_shared", program)
    end
  end

  def create_indice(index_name, program)
    return if Client.indices.exists(index: index_name)

    Client.indices.create \
      index: index_name,
      body: { settings: Event.settings.to_hash, mappings: Event.mappings_hash(program) }
  end
end
