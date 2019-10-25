# frozen_string_literal: true

module Samples
  class Program
    def self.load
      %w[CDC GDAPH].each do |program_name|
        ::Program.create(name: program_name)
      end
    end
  end
end
