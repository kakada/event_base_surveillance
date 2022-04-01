# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                       :bigint           not null, primary key
#  code                     :string
#  color_required           :boolean          default(FALSE)
#  description              :text
#  display_order            :integer
#  entry_able               :boolean          default(TRUE)
#  field_type               :string
#  is_default               :boolean          default(FALSE)
#  is_milestone_datetime    :boolean          default(FALSE)
#  mapping_field            :string
#  mapping_field_type       :string
#  milestone_datetime_order :integer
#  name                     :string
#  relevant                 :string
#  required                 :boolean
#  template_file            :string
#  template_name            :string
#  tracking                 :boolean          default(FALSE)
#  validations              :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  mapping_field_id         :integer
#  milestone_id             :integer
#  section_id               :integer
#

module Fields
  class FileField < ::Field
    def kind
      :file
    end

    def self.es_datatype
      :text
    end
  end
end
