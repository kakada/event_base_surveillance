# frozen_string_literal: true

module ActiveRecord
  class Base
    # Validate that the the objects in +collection+ are unique
    # when compared against all their non-blank +attrs+. If not
    # add +message+ to the base errors.
    def validate_uniqueness_of_in_memory(collection, attrs, message)
      hashes = collection.inject({}) do |hash, record|
        key = attrs.map { |a| record.send(a).to_s }.join
        if key.blank? || record.marked_for_destruction?
          key = record.object_id
        end
        hash[key] = record unless hash[key]
        hash
      end

      if collection.length > hashes.length
        association = collection.class.to_s.split('::').first.pluralize.downcase
        self.errors.add(association, message)
      end
    end
  end
end
