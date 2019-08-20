# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id           :bigint           not null, primary key
#  name         :string
#  access_token :string
#  ip_address   :string
#  active       :boolean          default(TRUE)
#  permissions  :string           is an Array
#  program_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ApiKey < ApplicationRecord
  PERMISSIONS = %w[read write].freeze
  belongs_to :program

  validates :name, presence: true
  validates :ip_address, presence: true
  validates :access_token, presence: true, uniqueness: true
  before_validation :generate_access_token, on: :create
  before_validation :cleanup_permissions

  private

  def generate_access_token
    self.access_token = SecureRandom.hex
  end

  def cleanup_permissions
    return if permissions.blank?

    self.permissions = permissions.reject(&:blank?)
  end
end
