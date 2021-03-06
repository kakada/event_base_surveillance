# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  code               :string
#  color_required     :boolean          default(FALSE)
#  description        :text
#  display_order      :integer
#  entry_able         :boolean          default(TRUE)
#  field_type         :string
#  is_default         :boolean          default(FALSE)
#  mapping_field      :string
#  mapping_field_type :string
#  name               :string
#  relevant           :string
#  required           :boolean
#  tracking           :boolean          default(FALSE)
#  validations        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mapping_field_id   :integer
#  milestone_id       :integer
#  section_id         :integer
#

module Fields
  class SelectMultipleField < ::Field
    def kind
      :select_multiple
    end

    def self.es_datatype

    end
  end
end
