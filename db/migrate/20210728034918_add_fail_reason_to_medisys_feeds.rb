# frozen_string_literal: true

class AddFailReasonToMedisysFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :medisys_feeds, :fail_reason, :string
  end
end
