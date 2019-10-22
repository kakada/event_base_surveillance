# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  name       :string
#  token      :string
#  username   :string
#  password   :string
#  url        :string
#  type       :string
#  program_id :integer
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Webhook < ApplicationRecord
  belongs_to :program
  has_many :event_type_webhooks
  has_many :event_types, through: :event_type_webhooks

  validates :name, :type, presence: true
  validates :token, presence: true, if: -> { type == Webhooks::TokenAuth.name }
  validates :username, :password, presence: true, if: -> { type == Webhooks::BasicAuth.name }
  validates :url, presence: true, format: { with: %r{\A^(https?\://)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}((/|\?)\S*)?$\z} }

  def self.types
    [['Basic Auth', Webhooks::BasicAuth.name], ['Token Auth', Webhooks::TokenAuth.name]]
  end

  def notify(_params = {})
    raise 'you have to implement in subclass'
  end
end
