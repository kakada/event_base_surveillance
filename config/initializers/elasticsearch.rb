# frozen_string_literal: true

config = {
  host: "http://elasticsearch:9200/",
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exist?("config/elasticsearch.yml")
  config.merge!(YAML.load(ERB.new(File.read("config/elasticsearch.yml")).result)[Rails.env].deep_symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
