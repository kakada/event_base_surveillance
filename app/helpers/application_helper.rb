module ApplicationHelper
  def css_class_name
    prefix = params['controller'].downcase.split('/').join('-')
    subfix = params['action']

    "#{prefix}-#{subfix}"
  end

  def getCssActiveClass(name)
    if (params['controller'] == name)
      return 'active'
    end

    return nil
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, '#', class: "add_fields btn btn-outline-secondary", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
