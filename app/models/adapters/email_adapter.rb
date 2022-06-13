# frozen_string_literal: true

class Adapters::EmailAdapter
  attr_reader :notifier

  def initialize(notifier)
    @notifier = notifier
  end

  def process
    return unless notifier.enabled?

    params = { recipient: notifier.recipients.join(","), message: notifier.display_message, title: notifier.display_title }.stringify_keys

    ::EmailAdapterWorker.perform_async(params)
  end
end
