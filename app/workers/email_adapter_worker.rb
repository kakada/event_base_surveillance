# frozen_string_literal: true

class EmailAdapterWorker
  include Sidekiq::Worker

  def perform(option={})
    NotificationMailer.notify(option['recipient'], option['message'], option['title']).deliver_now
  end
end
