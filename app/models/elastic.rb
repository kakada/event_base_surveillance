# frozen_string_literal: true

class Elastic
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def reindex_documents
    clean_indices
    index_documents
  end

  private

  def clean_indices
    indices = [ {name: "#{Event.index_name}_#{program.format_name}", program: program} ]

    Program.where.not(id: program.id).each do |target_program|
      # if program == cdc then it shares to gdaph, so name is gdaph_p#{cdc.id}_shared
      # and it's schema follows cdc
      indices.concat([
        { name: "#{target_program.format_name}_p#{program.id}_shared", program: program },
        { name: "#{program.format_name}_p#{target_program.id}_shared", program: target_program }
      ])
    end

    indices.each do |indice|
      clear_index(indice[:name])
      create_indice(indice[:name], indice[:program])
    end
  end

  def clear_index(indice_name)
    begin; client.delete_by_query(index: indice_name, q: '*'); rescue; end
  end

  def create_indice(index_name, _program)
    return if client.indices.exists(index: index_name)

    client.indices.create \
      index: index_name,
      body: { settings: Event.settings.to_hash, mappings: Event.mappings_hash(_program) }
  end

  def index_documents
    program.events.each do |event|
      IndexerWorker.perform_async(:index, event.id, event.program_id)
    end
  end

  def client
    @client ||= ::Elasticsearch::Model.client
  end
end
