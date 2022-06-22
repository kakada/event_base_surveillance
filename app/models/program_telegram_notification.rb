# frozen_string_literal: true

class ProgramTelegramNotification < ApplicationRecord
  belongs_to :program
  belongs_to :user
end
