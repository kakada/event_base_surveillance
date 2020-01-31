# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  uuid          :string(36)       not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  program_id    :integer
#  location_code :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  close         :boolean          default(FALSE)
#

class Event < ApplicationRecord
  include Events::Searchable
  include Events::Callback
  include Events::TemplateField
  include Events::FieldValueValidation
  include Events::TraceableField

  # Association
  belongs_to :event_type
  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :program
  belongs_to :location, foreign_key: :location_code, optional: true
  has_many   :event_milestones, foreign_key: :event_uuid, primary_key: :uuid, dependent: :destroy
  has_many   :field_values, as: :valueable, dependent: :destroy
  has_many   :tracings, as: :traceable, dependent: :destroy
  belongs_to :link_parent, class_name: 'Event', foreign_key: :link_uuid, optional: true
  has_many   :link_children, class_name: 'Event', foreign_key: :link_uuid

  # History
  has_associated_audits

  # Deligation
  delegate :name, :color, to: :event_type, prefix: :event_type
  delegate :name, to: :program, prefix: true
  delegate :enable_telegram?, to: :program, prefix: false
  delegate :enable_email_notification?, to: :program, prefix: false
  delegate :email, to: :creator, prefix: true
  delegate :latlng, to: :location, prefix: true, allow_nil: true

  # Validation
  validates :event_type_id, presence: true

  # Callback
  before_validation :set_program_id
  before_validation :assign_location
  before_create :secure_uuid

  after_create :set_event_progress

  # Scope
  default_scope { order(updated_at: :desc) }

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }
  accepts_nested_attributes_for :event_milestones, allow_destroy: true

  # Class Methods
  def self.filter(params)
    arr = keywords(params[:keyword])
    scope = all
    scope = scope.joins(:field_values).where('field_values.field_code = ? and field_values.value = ?', arr[0], arr[1]) if arr.present?
    scope = scope.joins(:field_values).where('field_values.field_code = ? and field_values.value >= ?', 'event_date', params[:start_date]) if params[:start_date].present?
    scope = scope.joins(:event_type).where('events.uuid LIKE ? OR LOWER(event_types.name) LIKE ?', "%#{params[:search]}%", "%#{params[:search].downcase}%") if params[:search].present?
    scope
  end

  # "risk_level: 'high'" => ["risk_level", "high"]
  def self.keywords(keyword)
    return [] unless keyword.present?

    keyword.gsub(/\s/, '').gsub(/"/, '').gsub(/'/, '').split(':')
  end

  # Instant Methods
  def conducted_at
    @conducted_at ||= field_values.find_by(field_code: 'report_date').value
  end

  def location_name(reverse = false, delimeter = ',')
    @location_name ||= (reverse ? addresses.reverse : addresses).map(&:name_km).join(delimeter)
  end

  def milestone
    @milestone ||= program.milestones.root
  end

  def telegram_message
    @telegram_message ||= MessageInterpretor.new(milestone.message.message, uuid).message
  end

  def set_event_progress
    fv = field_values.find_or_initialize_by(field_code: 'progress')
    fv.value = milestone.name
    fv.field_id ||= milestone.fields.find_by(code: 'progress').id
    fv.save
  end

  private

  def secure_uuid
    self.uuid ||= SecureRandom.hex(4)

    return unless self.class.exists?(uuid: uuid)

    self.uuid = SecureRandom.hex(4)
    secure_uuid
  end

  def addresses
    arr = []
    %w[province_id district_id commune_id village_id].each do |code|
      fv = field_values.find_by(field_code: code)
      next if fv.nil? || fv.value.blank?

      address = "Pumi::#{code.split('_').first.titlecase}".constantize.find_by_id(fv.value)
      next if address.nil?

      arr.push(address)
    end

    arr
  end

  def assign_location
    loc_code = %w[village_id commune_id district_id province_id].map do |code|
      field_values.select { |fv| fv.field_code == code }.first.try(:value)
    end.reject(&:blank?).first

    return if loc_code.blank?

    self.location_code = loc_code
  end

  def set_program_id
    creator && self.program_id = creator.program_id
  end
end
