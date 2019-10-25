# frozen_string_literal: true

module Samples
  class User
    def self.load
      cdc = ::Program.find_by name: 'CDC'
      gdaph = ::Program.find_by name: 'GDAPH'

      users = [
        { email: 'admin@instedd.org', role: :system_admin, program_id: nil },
        { email: 'cdc@program.org', role: :program_admin, program_id: cdc.id },
        { email: 'gdaph@program.org', role: :program_admin, program_id: gdaph.id },
        { email: 'staff@cdc.org', role: :staff, program_id: cdc.id },
        { email: 'staff@gdaph.org', role: :staff, program_id: gdaph.id },
        { email: 'guest@cdc.org', role: :guest, program_id: cdc.id },
        { email: 'guest@gdaph.org', role: :guest, program_id: gdaph.id }
      ]

      users.each do |user|
        u = ::User.new(email: user[:email], role: user[:role], password: '123456', program_id: user[:program_id])
        u.confirm
      end
    end
  end
end
