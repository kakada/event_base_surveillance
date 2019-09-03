module Events::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    index_name    "events"
    document_type "test"

    mapping do
    end
  end
end
