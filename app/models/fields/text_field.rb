# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  code               :string
#  name               :string
#  field_type         :string
#  required           :boolean
#  mapping_field      :string
#  mapping_field_type :string
#  display_order      :integer
#  milestone_id       :integer
#  is_default         :boolean          default(FALSE)
#  entry_able         :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  color_required     :boolean          default(FALSE)
#  validations        :text
#  tracking           :boolean          default(FALSE)
#

module Fields
  class TextField < ::Field
    def kind
      :text
    end

    def self.es_datatype
      :text
    end
  end
end
