# frozen_string_literal: true

# == Schema Information
#
# Table name: telegram_black_lists
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :string
#

class TelegramBlackList < ApplicationRecord
end
