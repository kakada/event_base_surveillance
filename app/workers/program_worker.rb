# frozen_string_literal: true

class ProgramWorker
  include Sidekiq::Worker

  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL']

  def perform(program_id)
    program = Program.find_by(id: program_id)
    return if program.nil?

    Client.indices.create \
      index: "#{Event.index_name}_#{program.name.downcase.split(' ').join('_')}",
      body: { settings: Event.settings.to_hash, mappings: Event.mappings_hash(program) }
  end
end
