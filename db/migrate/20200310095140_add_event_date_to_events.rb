class AddEventDateToEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :events, :event_date, :datetime

    migrate_event_date
  end

  def down
    remove_column :events, :event_date
  end

  private
    def migrate_event_date
      Event.all.includes(:field_values).each do |event|
        fv = event.field_values.select{ |fv| fv.field_code == 'event_date'}.first
        event.update_attributes(event_date: fv.es_value)
      end
    end
end
