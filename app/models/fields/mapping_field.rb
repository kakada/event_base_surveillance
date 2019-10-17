# frozen_string_literal: true

module Fields
  class MappingField < ::Field
    def kind
      :mapping
    end
  end
end
