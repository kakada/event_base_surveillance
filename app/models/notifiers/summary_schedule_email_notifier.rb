class Notifiers::SummaryScheduleEmailNotifier
  attr_reader :schedule

  def initialize(schedule)
    @schedule = schedule
  end

  def enabled?
    schedule.enabled? &&
    schedule.channels.include?('email')
  end

  def recipients
    schedule.emails
  end

  def display_message
    schedule.display_message
  end

  def display_title
    "Summary Report for #{schedule.program.name}"
  end

  def bot_token
    raise "It is for telegram channel only"
  end
end
