# frozen_string_literal: true

require "rails_helper"

RSpec.describe TelegramWebhooks::Message, type: :model do
  describe "#process" do
    let!(:bot) { create(:telegram_bot, token: "1234:abcd") }
    let(:program) { bot.program }

    subject { described_class.new(message) }

    context "new_chat_member" do
      let(:message) {
        {
          "message_id" => 1,
          "from" => { "id" => 1111, "is_bot" => false, "first_name" => "Sokly", "last_name" => "Heng", "language_code" => "en" },
          "chat" => { "id" => 123, "title" => "testing ebs group", "type" => "group", "all_members_are_administrators" => true },
          "new_chat_member" => { "id" => 1234, "is_bot" => true, "first_name" => "ebs_bot", "username" => "ebs_system_bot" }
        }
      }

      context "no chat_group" do
        it "creates an active chat group" do
          expect { subject.process }.to change { ChatGroup.count }.by 1
        end
      end

      context "has chat_group" do
        let!(:chat_group) { create(:chat_group, :telegram, chat_id: "123", is_active: false, program_id: program.id) }

        it "updates the chat_group to active" do
          subject.process

          expect(chat_group.reload.is_active).to be_truthy
        end
      end
    end

    context "left_chat_member" do
      let(:message) {
        {
          "message_id" => 564,
          "from" => { "id" => 1111, "is_bot" => false, "first_name" => "Sokly", "last_name" => "Heng", "language_code" => "en" },
          "chat" => { "id" => 123, "title" => "testing ebs group", "type" => "group", "all_members_are_administrators" => true },
          "left_chat_member" => { "id" => 1234, "is_bot" => true, "first_name" => "ebs_bot", "username" => "ebs_system_bot" }
        }
      }
      context "no chat_group" do
        it "creates an chat group" do
          expect { subject.process }.to change { ChatGroup.count }.by 1
        end

        it "creates an inactive chat group" do
          subject.process
          expect(program.chat_groups.last.is_active).to be_falsey
        end
      end

      context "has chat_group" do
        let!(:chat_group) { create(:chat_group, :telegram, chat_id: "123", is_active: true, program_id: program.id) }

        it "updates the chat_group to inactive" do
          subject.process

          expect(chat_group.reload.is_active).to be_falsey
        end
      end
    end

    context "migrate_to_chat_id" do
      let(:message) {
        {
          "message_id" => 564,
          "migrate_to_chat_id" => -123,
          "from" => { "id" => 1111, "is_bot" => false, "first_name" => "Sokly", "last_name" => "Heng", "language_code" => "en" },
          "chat" => { "id" => 123, "title" => "testing ebs group", "type" => "group", "all_members_are_administrators" => true }
        }
      }

      context "no chat_group" do
        it "do nothing" do
          expect { subject.process }.to change { ChatGroup.count }.by 0
        end
      end

      context "has chat_group" do
        let!(:chat_group) { create(:chat_group, :telegram, chat_id: "123", is_active: true, program_id: program.id) }

        it "update the chat_group to super group" do
          subject.process
          chat_group.reload

          expect(chat_group.chat_id).to eq "-123"
          expect(chat_group.chat_type).to eq ChatGroup::TELEGRAM_SUPER_GROUP
        end
      end
    end
  end
end
