# frozen_string_literal: true

module Fields
  class FileField < ::Field
    def kind
      :file
    end
  end
end
