# frozen_string_literal: true

class AddProgramIdToMedisysFeeds < ActiveRecord::Migration[5.2]
  def up
    add_column :medisys_feeds, :program_id, :integer

    Rake::Task['medisys_feed:migrate_program_id'].invoke
  end

  def down
    remove_column :medisys_feeds, :program_id
  end
end
