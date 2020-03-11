# frozen_string_literal: true

module MapsHelper
  def select_options(user, event_types)
    event_types.map do |event_type|
      label = event_type.name
      label = "#{label} (#{t('map.shared_from')} #{event_type.program_name})" if shared_event?(user, event_type)

      option = []
      option.push(label)
      option.push(event_type.id)
      option
    end
  end
end
