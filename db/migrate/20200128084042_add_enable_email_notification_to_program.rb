# frozen_string_literal: true

class AddEnableEmailNotificationToProgram < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :enable_email_notification, :boolean, default: false
  end
end
