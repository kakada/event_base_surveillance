# frozen_string_literal: true

module Samples
  class Program
    def self.load
      u = ::User.new(email: 'admin@instedd.org', role: :system_admin, password: '123456', program_id: nil)
      u.confirm

      %w[CDC GDAHP].each do |program_name|
        u.programs.create(name: program_name)
      end
    end
  end
end
