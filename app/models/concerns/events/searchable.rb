module Events
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      # include Elasticsearch::Model::Callbacks

      index_name    "ebs-development"
      document_type "event"

      mapping do

      end

      def as_indexed_json(options={})
        # option = self.as_json(
        #   include: { report: {only: [:phd_id]},
        #              variable: {only: [:verboice_name]}
        #            })

        # option['value'] = option['value'].to_i
        # option['report']['phd_name'] = self.report.phd.try(:name)

        self.as_json
      end
    end
  end
end
