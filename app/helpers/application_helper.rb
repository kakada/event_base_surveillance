module ApplicationHelper
  def css_class_name
    prefix = params['controller'].downcase.split('/').join('-')
    subfix = params['action']

    "#{prefix}-#{subfix}"
  end
end
