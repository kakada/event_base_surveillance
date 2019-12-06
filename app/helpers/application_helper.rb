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

    nil
  end

  def link_to_add_fields(name, f, association, option = {})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder, option: option)
    end

    link_to(name, '#', class: "add_#{association} btn", data: { id: id, fields: fields.gsub("\n", '') })
  end

  def get_pumi_location(code)
    kind = pumi_location_type(code)
    return "Pumi::#{kind.titlecase}".constantize.find_by_id code
  end

  def pumi_location_type(code)
    case code.length
    when 2
      return 'province'
    when 4
      return 'district'
    when 6
      return 'commune'
    else
      return 'village'
    end
  end
end
