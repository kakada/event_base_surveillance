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
  before_validation :generate_access_token, on: :create

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
