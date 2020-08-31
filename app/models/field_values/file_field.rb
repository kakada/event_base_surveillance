# frozen_string_literal: true

# == Schema Information
#
# Table name: field_values
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  field_code     :string
#  value          :string
#  color          :string
#  values         :text             is an Array
#  properties     :text
#  image          :string
#  file           :string
#  valueable_id   :string
#  valueable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#

module FieldValues
  class FileField < ::FieldValue
    def html_tag
      "
        <div>
          <a href='#{Rails.application.routes.url_helpers.download_path(file: file.path)}' target='_blank' style='color: #007bff'>
            #{file_identifier}
          </a>
        </div>
      "
    end
  end
end
