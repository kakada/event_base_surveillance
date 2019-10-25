# frozen_string_literal: true

require 'samples/elasticsearch'

namespace :elasticsearch do
  desc 'recreate indices and reindex all documents'
  task recreate: :environment do
    Samples::Elasticsearch.load
  end
end
