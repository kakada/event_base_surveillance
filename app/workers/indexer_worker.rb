# frozen_string_literal: true

class IndexerWorker
  include Sidekiq::Worker

  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL']

  def perform(operation, event_uuid, program_id)
    logger.debug [operation, "ID: #{event_uuid}"]

    program = Program.find(program_id)
    index_name = "#{Event.index_name}_#{program.name.downcase.split(' ').join('_')}"

    case operation.to_s
    when /index/
      event = Event.find_by(uuid: event_uuid)
      return if event.nil?

      Client.index index: index_name, id: event.uuid, body: event.__elasticsearch__.as_indexed_json
    when /delete/
      begin
        Client.delete index: index_name, id: event_uuid
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.debug "Event not found, ID: #{event_uuid}"
      end
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
