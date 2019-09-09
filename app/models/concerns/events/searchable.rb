module Events::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :location_name, type: :text
      indexes :location, type: :geo_point
    end

    def as_indexed_json(_options = {})
      self.as_json.merge(
        location_name: self.location_name,
        location: {lat: self.latitude, lon: self.longitude}
      )
    end
  end
end
