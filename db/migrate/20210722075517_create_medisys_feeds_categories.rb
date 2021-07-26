class CreateMedisysFeedsCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :medisys_feeds_categories do |t|
      t.integer :medisys_feed_id
      t.integer :medisys_category_id

      t.timestamps
    end
  end
end
