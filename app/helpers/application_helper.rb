module ApplicationHelper
  def provider_from_class_name(class_names)
    class_names.to_s.split('::').last.underscore.downcase
  end
end
