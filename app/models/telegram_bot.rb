# frozen_string_literal: true

class TelegramBot
  attr_reader :bot

  def initialize()
    @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'], ENV['TELEGRAM_USERNAME'])
  end

  def chats
    bot.get_updates['result'].map do |res|
      chat = res['message']['chat']
      label = chat['type'] == 'private' ? "#{chat['first_name']} #{chat['last_name']}" : chat['title']
      value = chat['id']

      [label, value]
    end
  end
end
