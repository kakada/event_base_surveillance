# == Schema Information
#
# Table name: api_keys
#
#  id           :bigint           not null, primary key
#  name         :string
#  access_token :string
#  ip_address   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ApiKey < ApplicationRecord

  validates :name, presence: true
  validates :ip_address, presence: true
  validates :access_token, presence: true, uniqueness: true
  validates :permissions, presence: true
  before_validation :generate_access_token, on: :create
  before_validation :cleanup_permissions

  PERMISSIONS = %w(read write)

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def cleanup_permissions
    return if permissions.blank?

    self.permissions = permissions.reject(&:blank?)
  end
end
