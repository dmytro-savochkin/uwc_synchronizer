module ApplicationHelper
  def provider_from_class_name(class_name)
    class_name.to_s.split('::').last.underscore.downcase
  end
end
