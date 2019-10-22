class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string   :name
      t.string   :token
      t.string   :username
      t.string   :password
      t.string   :url
      t.string   :type
      t.integer  :program_id
      t.boolean  :active, default: true

      t.timestamps
    end
  end
end
