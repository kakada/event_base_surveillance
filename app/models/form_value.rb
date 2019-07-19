# == Schema Information
#
# Table name: form_values
#
#  id           :bigint           not null, primary key
#  event_id     :integer
#  form_id      :integer
#  submitter_id :integer
#  priority     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FormValue < ApplicationRecord
end
