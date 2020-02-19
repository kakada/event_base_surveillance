# frozen_string_literal: true

class CreateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :fields do |t|
      t.string    :code
      t.string    :name
      t.string    :field_type
      t.boolean   :required
      t.string    :mapping_field
      t.string    :mapping_field_type
      t.integer   :display_order
      t.integer   :milestone_id
      t.boolean   :is_default, default: false
      t.boolean   :entry_able, default: true

      t.timestamps
    end
  end
end
