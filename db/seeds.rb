# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Programs

program_cdc = Program.create(name: 'CDC')
program_gdaph = Program.create(name: 'GDAPH')


# Users
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

# Event type
event_types = [
  {
    name: 'Unknown',
    user_id: User.find_by(email: 'cdc@program.org').id,
    color: "##{SecureRandom.hex(3)}",
    default: true
  },
  {
    name: 'Influenza',
    user_id: User.find_by(email: 'cdc@program.org').id,
    color: "##{SecureRandom.hex(3)}"
  }
]

event_types.each do |obj|
  EventType.create(obj)
end

# Milestone
milestones = [
  # {
  #   name: 'New',
  #   fields_attributes: [
  #     { name: "Source of information", field_type: "select_one", field_options_attributes: [{name: "Hotline"}, {name: "RRT"}, {name: "Media monitoring"}, {name: "CamEWARN"}, {name: "CamLIS"}, {name: "NGO Partners"}, {name: "Other"}]},
  #     { name: "Additional information", field_type: "text"},
  #     { name: "WHO notified date", field_type: "date"},
  #     { name: "Status of report", field_type: "select_one", field_options_attributes: [{ name: "For verification by RRT" }, { name: "Verfified (confirmed)" }, { name: "False report" }, { name: "Refer to other agency" }]},
  #     { name: "Verification Date", field_type: "date"}
  #   ]
  # },
  {
    name: "Risk Assessment",
    fields_attributes: [
      { name: "# of Male", field_type: "Fields::IntegerField" },
      { name: "# of Female", field_type: "Fields::IntegerField" },
      { name: "# of Hospitalized", field_type: "Fields::IntegerField" },
      { name: "# of Recovered", field_type: "Fields::IntegerField" },
      { name: "# of Death", field_type: "Fields::IntegerField" },
      { name: "Summary", field_type: "Fields::NoteField" },
      { name: "Risk Assessment conducted", field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Yes" }, { name: "No" }] },
      { name: "Risk Level", field_type: "Fields::MappingField", mapping_field: 'risk_level', mapping_field_type: "select_one", field_options_attributes: [{ name: "Low", color: '#51b8b8' }, { name: "Moderate", color: '#51b865' }, { name: "High", color: '#d68bb2' }, { name: "Very High", color: '#e81c2a' }] },
      { name: "Risk assessment date", field_type: "Fields::DateField" },
    ]
  },
  {
    name: "Investigation",
    fields_attributes: [
      { name: "Investigation conducted", field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Yes" }, { name: "No" }] },
      { name: "Investigation date", field_type: "Fields::DateField" },
      { name: "Action Taken", field_type: "Fields::NoteField" },
      { name: "Samples collected", field_type: "Fields::TextField" },
      { name: "Sample collected date", field_type: "Fields::DateField" },
      { name: "Laboratory Results", field_type: "Fields::TextField" },
      { name: "Status of event", field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Follow up" }, { name: "Closed" }] }
    ]
  },
  {
    name: "Conclusion",
    fields_attributes: [
      { name: "Conclusion", field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Methanol poisoning" }, { name: "H5N1" }, { name: "Khmer Noodle poisoning" }, { name: "H3N2 cluster" }, { name: "Parasite" }, { name: "Bread with meal" }, { name: "Water borne" }, { name: "Food borne" }, { name: "Zoonoic" }, { name: "Polultry death" }, { name: "Dog bites" }, { name: "Snake bites" }, { name: "Fever with rash" }, { name: "Acute diarrhea" }, { name: "Acute flaccid paralysis" }, { name: "Environmental pollution" }, { name: "uspected nosocomial" }, { name: "Skin" }, { name: "Meniningoencephalitis syndrome" }, { name: "Acute jaundice" }, { name: "Meningitis or encephalitis" }, { name: "Acute hemorrhagic fever" }, { name: "Acute respiratory infection" }]},
      { name: "Close Date", field_type: "Fields::DateField"}
    ]
  }
]

milestones.each do |milestone|
  program_cdc.milestones.create(milestone)
end
