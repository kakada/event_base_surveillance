# frozen_string_literal: true

module Fields
  class SelectOneField < ::Field
    def kind
      :select_one
    end
  end
end
