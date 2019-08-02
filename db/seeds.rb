# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

program_cdc = Program.create(name: 'CDC')
program_gdaph = Program.create(name: 'GDAPH')

users = [
  { email: 'admin@instedd.org', role: :system_admin, program_id: nil },
  { email: 'cdc@program.org', role: :program_admin, program_id: program_cdc.id },
  { email: 'gdaph@program.org', role: :program_admin, program_id: program_gdaph.id },
  { email: 'staff@cdc.org', role: :staff, program_id: program_cdc.id },
  { email: 'staff@gdaph.org', role: :staff, program_id: program_gdaph.id },
  { email: 'guest@cdc.org', role: :guest, program_id: program_cdc.id },
  { email: 'guest@gdaph.org', role: :guest, program_id: program_gdaph.id },
]
users.each do |user|
  u = User.new(email: user[:email], role: user[:role], password: '123456', program_id: user[:program_id])
  u.confirm
end

# Create Event type
event_type = User.find_by(email: 'cdc@program.org').event_types.create(name: 'H5N1')

# Create Forms
form_types = [
  { name: 'New' },
  { name: 'Assessment'},
  { name: 'Investigation'}
]

fields = [
  { name: 'Name', field_type: 'text_field' },
  { name: 'Case', field_type: 'text_field' }
]

form_types.each do |form|
  f = event_type.form_types.create(name: form[:name])

  # fields.each do |field|
  #   f.fields.create(name: field[:name], field_type: field[:field_type])
  # end
end
