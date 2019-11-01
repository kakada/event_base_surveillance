# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  name            :string
#  enable_telegram :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#

class Program < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many  :users
  has_many  :client_apps
  has_many  :events
  has_many  :event_types
  has_many  :milestones
  has_many  :webhooks

  validates :name, presence: true

  after_create :create_root_milestone
  after_create :create_unknown_event_type
  after_create { ProgramWorker.perform_async(id) }

  def format_name
    name.downcase.split(' ').join('_')
  end

  private

  def create_root_milestone
    milestones.create_root(creator_id)
  end

  def create_unknown_event_type
    event_types.create_root(creator_id)
  end
end
