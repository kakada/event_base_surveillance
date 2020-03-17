class RemoveFieldIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :fields, name: 'index_fields_on_milestone_id_and_code'
    remove_index :fields, name: 'index_fields_on_milestone_id_and_name'
  end
end
