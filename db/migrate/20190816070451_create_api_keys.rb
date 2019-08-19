class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :access_token
      t.string :ip_address

      t.timestamps
    end
  end
end
