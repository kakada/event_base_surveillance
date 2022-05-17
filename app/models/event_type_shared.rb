# frozen_string_literal: true

# == Schema Information
#
# Table name: event_type_shareds
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  event_type_id :integer
#  program_id    :integer
#


class EventTypeShared < ApplicationRecord
  audited associated_with: :event_type

  belongs_to :event_type
  belongs_to :program
end
