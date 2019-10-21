class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string   :name
      t.string   :api_key
      t.string   :url
      t.integer  :program_id

      t.timestamps
    end
  end
end
