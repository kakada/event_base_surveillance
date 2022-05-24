# frozen_string_literal: true

# == Schema Information
#
# Table name: email_notifications
#
#  id           :bigint           not null, primary key
#  milestone_id :integer
#  message_id   :integer
#  emails       :text             default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EmailNotification < ApplicationRecord
  belongs_to :message, optional: true
end
