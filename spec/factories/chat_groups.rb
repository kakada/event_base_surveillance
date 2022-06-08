# frozen_string_literal: true

FactoryBot.define do
  factory :chat_group do
    chat_type   { "group" }
    is_active   { true }
    title       { "test group" }
    chat_id     { "123" }
  end
end
