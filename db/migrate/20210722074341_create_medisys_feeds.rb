class CreateMedisysFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :medisys_feeds do |t|
      t.string :title
      t.string :link
      t.string :description
      t.string :keywords
      t.datetime :pub_date
      t.string :guid
      t.string :iso_language
      t.string :georss_point
      t.integer :medisy_id
      t.string :category_trigger
      t.string :source_name
      t.string :source_url
      t.integer :medisys_country_id

      t.timestamps
    end
  end
end
