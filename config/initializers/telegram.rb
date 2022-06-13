# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :file_store, Rails.root.join("tmp", "session_store")

Telegram.bots_config = {
  default: nil
}
