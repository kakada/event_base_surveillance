# frozen_string_literal: true

require "rake"

class AddEventDateToEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :events, :event_date, :datetime

    Rake::Task["event:migrate_event_date"].invoke
  end

  def down
    remove_column :events, :event_date
  end
end
