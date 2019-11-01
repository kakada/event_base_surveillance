# frozen_string_literal: true

module Samples
  class Elasticsearch
    def self.load
      delete_indices
      create_indices
      index_documents
    end

    private_class_method

    def self.index_documents
      ::Program.all.each do |program|
        program.events.each do |event|
          # events_cdc
          index_document("#{::Event.index_name}_#{program.format_name}", event)

          next unless event.event_type.shared?

          ::Program.where.not(id: program.id).each do |target_program|
            # gdaph_p#{cdc.id}_shared
            index_name = "#{target_program.format_name}_p#{program.id}_shared"
            index_document(index_name, event)
          end
        end
      end
    end

    def self.delete_indices
      ::Program.all.each do |program|
        delete_indice("#{::Event.index_name}_#{program.format_name}")

        ::Program.where.not(id: program.id).each do |target_program|
          # gdaph_p#{cdc.id}_shared
          delete_indice("#{program.format_name}_p#{target_program.id}_shared")
          # cdc_p#{gdaph.id}_shared
          delete_indice("#{target_program.format_name}_p#{program.id}_shared")
        end
      end
    end

    def self.create_indices
      ::Program.all.each do |program|
        create_indice("#{::Event.index_name}_#{program.format_name}", program)

        ::Program.where.not(id: program.id).each do |target_program|
          # gdaph_p#{cdc.id}_shared
          create_indice("#{program.format_name}_p#{target_program.id}_shared", target_program)
          # cdc_p#{gdaph.id}_shared
          create_indice("#{target_program.format_name}_p#{program.id}_shared", program)
        end
      end
    end

    def self.delete_indice(index_name)
      return unless client.indices.exists(index: index_name)

      begin
        client.indices.delete index: index_name
      rescue StandardError
        nil
      end
    end

    def self.create_indice(index_name, program)
      return if client.indices.exists(index: index_name)

      client.indices.create \
        index: index_name,
        body: { settings: ::Event.settings.to_hash, mappings: ::Event.mappings_hash(program) }
    end

    def self.index_document(index_name, event)
      client.index index: index_name, id: event.uuid, body: event.as_indexed_json
    end

    def self.client
      @@client ||= ::Elasticsearch::Model.client
    end
  end
end
