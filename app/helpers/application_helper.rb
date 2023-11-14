module ApplicationHelper
  include Pagy::Frontend
  def truncate_action_text(content, length: 100)
    truncate(strip_tags(content.to_s), length: length)
  end
end
