# frozen_string_literal: true

# == Schema Information
#
# Table name: template_fields
#
#  id            :bigint           not null, primary key
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  field_id      :integer
#  template_id   :integer
#


class TemplateField < ApplicationRecord
  belongs_to :template
  belongs_to :field
end
