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
end
