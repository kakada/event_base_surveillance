# frozen_string_literal: true

module Samples
  class User
    def self.load
      cdc = ::Program.find_by name: 'CDC'
      gdaph = ::Program.find_by name: 'GDAPH'

      users = [
        { email: 'cdc@program.org', role: :program_admin, program_id: cdc.id },
        { email: 'gdaph@program.org', role: :program_admin, program_id: gdaph.id },
        { email: 'staff@cdc.org', role: :staff, program_id: cdc.id, province_code: 'all' },
        { email: 'staff@gdaph.org', role: :staff, program_id: gdaph.id, province_code: 'all' },
        { email: 'guest@cdc.org', role: :guest, program_id: cdc.id, province_code: '01' },
        { email: 'guest@gdaph.org', role: :guest, program_id: gdaph.id, province_code: '01' }
      ]

      users.each do |user|
        u = ::User.new(email: user[:email], role: user[:role], password: '123456', program_id: user[:program_id])
        u.confirm
      end
    end
  end
end
