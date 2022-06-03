# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  full_name              :string
#  language_code          :string           default("km")
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  phone_number           :string
#  province_code          :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          not null
#  sign_in_count          :integer          default(0), not null
#  telegram_username      :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  program_id             :integer
#  telegram_chat_id       :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include Users::Confirmable
  include Users::Filter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: {
    system_admin: 1,
    program_admin: 2,
    staff: 3,
    guest: 4
  }

  ROLES = roles.keys.map { |r| [r.titlecase, r] }

  # Association
  belongs_to :location, foreign_key: :province_code, optional: true
  belongs_to :program, optional: true
  has_many :programs, foreign_key: :creator_id
  has_many :event_types
  has_many :events, foreign_key: :creator_id

  # Delegation
  delegate :name, to: :program, prefix: :program, allow_nil: true

  # Validation
  validates :role, presence: true
  validates :program_id, presence: true, unless: -> { role == 'system_admin' }
  validates :province_code, presence: true, if: -> { %(staff guest).include?(role.to_s) }
  validates :phone_number, uniqueness: { allow_blank: true }

  # Callback
  before_create :set_full_name
  before_create :set_province_code, if: :program_admin?

  def location
    super || Location.pumi_all_provinces.select { |p| p.id == province_code }.first
  end

  def set_full_name
    self.full_name ||= email.split('@').first
  end

  def telegram?
    @telegram ||= TelegramBot.has_system_bot? && telegram_chat_id.present?
  end

  def display_name
    email.split("@").first.upcase
  end

  private
    def set_province_code
      self.province_code = 'all'
    end
end
