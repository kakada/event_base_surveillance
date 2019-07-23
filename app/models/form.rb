# == Schema Information
#
# Table name: forms
#
#  id           :bigint           not null, primary key
#  event_id     :integer
#  form_type_id :integer
#  submitter_id :integer
#  priority     :string
#  properties   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Form < ApplicationRecord
  belongs_to :event
  belongs_to :form_type
  belongs_to :submitter, class_name: 'User'

  serialize :properties, Hash

  validate :validate_properties, on: [:create, :update]

  def validate_properties
    form_type.fields.each do |field|
      if field.required? && properties[field.name.downcase].blank?
        errors.add field.name.downcase, "cannot be blank"
      end
    end
  end
end
