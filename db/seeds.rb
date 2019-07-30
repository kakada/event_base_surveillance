# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
program = Program.create(name: 'CDC')

u = User.new(email: 'admin@instedd.org', role: :system_admin, password: '123456', program_id: program.id)
u.confirm


# Create Event type
event_type = u.event_types.create(name: 'H5N1')

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

  fields.each do |field|
    f.fields.create(name: field[:name], field_type: field[:field_type])
  end
end
