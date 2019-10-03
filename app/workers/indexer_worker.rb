class IndexerWorker
  include Sidekiq::Worker

  def perform(action, event_uuid)
    event = Event.find(event_uuid)

    return if event.nil?

    event.__elasticsearch__.send("#{action}_document")
  end
end
