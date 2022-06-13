# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_notification, class: "Notifications::TelegramNotification" do
    message
    milestone { message.milestone }

    trait :with_chat_groups do
      chat_group_ids { [create(:chat_group).id] }
    end
  end
end
