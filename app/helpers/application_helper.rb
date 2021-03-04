# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def css_class_name
    prefix = params['controller'].downcase.split('/').join('-')
    subfix = params['action']

    "#{prefix}-#{subfix}"
  end

  def get_css_active_class(name)
    return 'active' if params['controller'] == name
  end

  def css_active_tab(is_active)
    return "active" if is_active
  end

  def link_to_add_fields(name, f, association, option = {})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder, option: option)
    end

    link_to(name, '#', class: "add_#{association} btn", data: { id: id, fields: fields.gsub("\n", '') })
  end
end
