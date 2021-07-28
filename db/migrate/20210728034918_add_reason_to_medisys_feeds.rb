# frozen_string_literal: true

class AddReasonToMedisysFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :medisys_feeds, :reason, :string
  end
end
