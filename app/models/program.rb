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
#

class Program < ApplicationRecord
  has_many  :users
  has_many  :client_apps
  has_many  :events
  has_many  :event_types
  has_many  :milestones

  validates :name, presence: true

  after_create :create_root_milestone
  after_create { ProgramWorker.perform_async(id) }

  private

  def create_root_milestone
    milestones.create_root
  end
end
