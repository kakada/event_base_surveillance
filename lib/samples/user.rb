# frozen_string_literal: true

module Samples
  class User
    def self.load
      cdc = ::Program.find_by name: "CDC"
      gdahp = ::Program.find_by name: "GDAHP"

      users = [
        { email: "cdc@program.org", role: :program_admin, program_id: cdc.id },
        { email: "gdahp@program.org", role: :program_admin, program_id: gdahp.id },
        { email: "staff@cdc.org", role: :staff, program_id: cdc.id, province_code: "all" },
        { email: "staff@gdahp.org", role: :staff, program_id: gdahp.id, province_code: "all" },
        { email: "guest@cdc.org", role: :guest, program_id: cdc.id, province_code: "01" },
        { email: "guest@gdahp.org", role: :guest, program_id: gdahp.id, province_code: "01" }
      ]

      users.each do |user|
        u = ::User.new(user.merge({ password: "123456" }))
        u.confirm
      end
    end
  end
end
