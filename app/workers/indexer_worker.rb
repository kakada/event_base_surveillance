# frozen_string_literal: true

class IndexerWorker
  include Sidekiq::Worker

  logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], logger: logger

  def perform(operation, event_uuid)
    logger.debug [operation, "ID: #{event_uuid}"]

    case operation.to_s
    when /index/
      event = Event.find_by(uuid: event_uuid)
      return if event.nil?

      Client.index index: 'events', id: event.uuid, body: event.__elasticsearch__.as_indexed_json
    when /delete/
      begin
        Client.delete index: 'events', id: event_uuid
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.debug "Event not found, ID: #{event_uuid}"
      end
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
