class Adapter
  def self.for(notifier, type = :email)
    "Adapters::#{type.to_s.camelize}Adapter".constantize.new(notifier)
  end
end
