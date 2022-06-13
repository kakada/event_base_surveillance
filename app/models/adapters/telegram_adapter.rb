# frozen_string_literal: true

class Adapters::TelegramAdapter
  attr_reader :notifier

  def initialize(notifier)
    @notifier = notifier
  end

  def process
    return unless notifier.enabled?

    notifier.recipients.each do |recipient|
      params = { recipient: recipient, message: notifier.display_message, bot_token: notifier.bot_token }.stringify_keys

      ::TelegramAdapterWorker.perform_async(params)
    end
  end
end
