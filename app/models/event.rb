# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  close         :boolean          default(FALSE)
#  event_date    :datetime
#  link_uuid     :string
#  location_code :string
#  uuid          :string(36)       not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :integer
#  event_type_id :integer
#  program_id    :integer
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
  delegate :shared?, to: :event_type, prefix: false
  delegate :name, to: :program, prefix: true
  delegate :enable_telegram?, to: :program, prefix: false
  delegate :enable_email_notification?, to: :program, prefix: false
  delegate :email, to: :creator, prefix: true
  delegate :latlng, to: :location, prefix: true, allow_nil: true

  # Validation
  validates :event_type_id, presence: true

  # Callback
  before_validation :set_program_id
  before_validation :assign_nil_locations
  before_validation :set_location_code
  before_create :secure_uuid

  after_create :set_event_progress


  # Scope
  scope :order_desc, -> { order(event_date: :desc) }

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }
  accepts_nested_attributes_for :event_milestones, allow_destroy: true

  # Class Methods
  def self.filter(params = {})
    keywords = get_keywords(params[:keyword])
    scope = all
    scope = scope.joins(:event_type).where('LOWER(event_types.name) LIKE ?', "%#{keywords[1].downcase}%") if keywords.present? && keywords[0] == 'suspected_event'
    scope = scope.joins(:field_values).where('field_values.field_code = ? and field_values.value = ?', keywords[0], keywords[1]) if keywords.present? && keywords[0] != 'suspected_event'
    scope = scope.where('event_date >= ?', params[:start_date]) if params[:start_date].present?
    scope = scope.where(event_type_id: params[:event_type_id]) if params[:event_type_id].present?
    scope = scope.joins(:event_type).where('events.uuid LIKE ? OR LOWER(event_types.name) LIKE ?', "%#{params[:search]}%", "%#{params[:search].downcase}%") if params[:search].present?
    scope
  end

  # "risk_level: 'high'" => ["risk_level", "high"]
  def self.get_keywords(keyword)
    return [] unless keyword.present?

    keyword.gsub(/\s/, '').gsub(/"/, '').gsub(/'/, '').split(':')
  end

  # Instant Methods
  def conducted_at
    @conducted_at ||= field_values.find_by(field_code: 'report_date').try(:value)
  end

  def location_name(address = 'address_km')
    return if location_code.blank?

    "Pumi::#{Location.location_kind(location_code).titlecase}".constantize.find_by_id(location_code).try("#{address}".to_sym)
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

  def with_field_value
    data = {}

    milestone.fields.pluck(:code).each do |code|
      data[code] = field_values.select { |fv| fv.field_code == code }.first.try(:value)
    end

    data
  end

  def verified?
    @verified ||= event_milestones.collect(&:milestone_id).include? program.milestones.verified.try(:id)
  end

  private
    def secure_uuid
      self.uuid ||= SecureRandom.hex(4)

      return unless self.class.exists?(uuid: uuid)

      self.uuid = SecureRandom.hex(4)
      secure_uuid
    end

    def assign_nil_locations
      fvs = %w[province_id district_id commune_id village_id].map do |code|
        field_values.select { |fv| fv.field_code == code }.first
      end

      clear_next = false
      fvs.each do |fv|
        next if fv.nil?

        fv.value = nil if clear_next == true
        clear_next = fv.value.blank?
      end
    end

    def set_location_code
      codes = %w[province_id district_id commune_id village_id].map do |code|
        field_values.select { |fv| fv.field_code == code }.first.try(:value).to_s
      end

      self.location_code = codes[codes.find_index('').to_i - 1]
    end

    def set_program_id
      self.program_id = creator.present? && creator.program_id
    end
end
