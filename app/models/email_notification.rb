# frozen_string_literal: true

class EmailNotification < ApplicationRecord
  belongs_to :message, optional: true

  
end
