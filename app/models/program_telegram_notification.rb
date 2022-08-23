# frozen_string_literal: true

# == Schema Information
#
# Table name: program_telegram_notifications
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :integer
#  user_id    :integer
#


class ProgramTelegramNotification < ApplicationRecord
  belongs_to :program
  belongs_to :user
end
