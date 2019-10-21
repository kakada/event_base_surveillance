# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  name       :string
#  api_key    :string
#  url        :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Webhook < ApplicationRecord
  belongs_to :program

  validates :name, :api_key, presence: true
  validates :url, format: { with: %r{\A^(https?\://)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}((/|\?)\S*)?$\z} }, allow_blank: true
end
