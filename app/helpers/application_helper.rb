module ApplicationHelper
  def provider_from_class_name(class_names)
    class_names.underscore.split('_').first
  end
end
