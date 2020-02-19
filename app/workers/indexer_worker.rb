# frozen_string_literal: true

class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'indexers'

  Client = Elasticsearch::Model.client

  def perform(operation, event_uuid, program_id)
    program = Program.find(program_id)

    case operation.to_s
    when /index/
      handle_index(event_uuid, program)
    when /delete/
      handle_delete(event_uuid, program)
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

  private
    def handle_index(event_uuid, program)
      event = Event.find_by(uuid: event_uuid)
      return if event.nil?

      # events_cdc
      index_document("#{Event.index_name}_#{program.format_name}", event)

      return unless event.event_type.shared?

      Program.where.not(id: program.id).each do |target_program|
        # gdaph_p#{cdc.id}_shared
        index_name = "#{target_program.format_name}_p#{program.id}_shared"
        index_document(index_name, event)
      end
    end

    def handle_delete(event_uuid, program)
      # events_cdc
      delete_document("#{Event.index_name}_#{program.format_name}", event_uuid)

      Program.where.not(id: program.id).each do |target_program|
        # gdaph_p#{cdc.id}_shared
        index_name = "#{target_program.format_name}_p#{program.id}_shared"
        delete_document(index_name, event_uuid)
      end
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      logger.debug "Event not found, ID: #{event_uuid}"
    end

    def index_document(index_name, event)
      Client.index index: index_name, id: event.uuid, body: event.as_indexed_json
    end

    def delete_document(index_name, event_uuid)
      Client.delete index: index_name, id: event_uuid
    end
end
