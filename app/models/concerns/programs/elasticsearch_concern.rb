# frozen_string_literal: true

module Programs
  module ElasticsearchConcern
    extend ActiveSupport::Concern

    included do
      def reindex_documents
        clean_indices
        index_documents
      end

      private
        def clean_indices
          indices = [ { name: "#{Event.index_name}_#{format_name}", program: self } ]

          Program.where.not(id: id).each do |target_program|
            # if program == cdc then it shares to gdaph, so name is gdaph_p#{cdc.id}_shared
            # and it's schema follows cdc
            indices.concat([
              { name: "#{target_program.format_name}_p#{id}_shared", program: self },
              { name: "#{format_name}_p#{target_program.id}_shared", program: target_program }
            ])
          end

          indices.each do |indice|
            clear_index(indice[:name])
            create_indice(indice[:name], indice[:program])
          end
        end

        def clear_index(indice_name)
          client.delete_by_query(index: indice_name, q: "*"); rescue
        end

        def create_indice(index_name, program)
          return if client.indices.exists(index: index_name)

          client.indices.create \
            index: index_name,
            body: { settings: Event.settings.to_hash, mappings: Event.mappings_hash(program) }
        end

        def index_documents
          events.each do |event|
            IndexerWorker.perform_async(:index, event.id, event.program_id)
          end
        end

        def client
          @client ||= ::Elasticsearch::Model.client
        end
    end
  end
end
