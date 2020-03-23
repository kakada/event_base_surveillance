class Template < ApplicationRecord
  belongs_to :program
  has_many :template_fields
  has_many :fields, through: :template_fields

  serialize :properties, Array

  def self.predefined_fields
    [
      { code: 'uuid', name: 'Uuid'},
      { code: 'event_type_name', name: 'Suspected Event'},
      { code: 'program_name', name: 'Program Name'},
      { code: 'location_name', name: 'Location Name'},
      { code: 'created_at', name: 'Created at'},
      { code: 'updated_at', name: 'Updated at'},
      { code: 'close', name: 'Close?'}
    ]
  end
end
