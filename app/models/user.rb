# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  role                   :integer          not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  program_id             :integer
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  enum role: {
    system_admin: 1,
    program_admin: 2,
    staff: 3,
    guest: 4
  }

  ROLES = roles.keys.map { |r| [r.titlecase, r] }

  belongs_to :location, foreign_key: :province_code, optional: true
  belongs_to :program, optional: true
  has_many :programs, foreign_key: :creator_id
  has_many :event_types
  has_many :events, foreign_key: :creator_id

  delegate :name, to: :program, prefix: :program, allow_nil: true

  validates :role, presence: true
  validates :program_id, presence: true, unless: -> { role == 'system_admin' }
  validates :province_code, presence: true, if: -> { %(staff guest).include?(role.to_s) }

  def password_match?
    errors[:password] << I18n.t('errors.messages.blank') if password.blank?
    errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
    errors[:password_confirmation] << I18n.translate('errors.messages.confirmation', attribute: 'password') if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def no_password?
    encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def location
    return unless province_code.present?

    if province_code == 'all'
      Pumi::Province.new(name_km: 'គ្រប់ខេត្ត/ក្រុង', name_en: 'All')
    else
      super || Pumi::Province.find_by_id(province_code)
    end
  end

  # class methods
  def self.filter(params)
    scope = all
    scope = scope.where('email LIKE ?', "%#{params[:email]}%") if params[:email].present?
    scope
  end

  protected
    def password_required?
      confirmed? ? super : false
    end
end
