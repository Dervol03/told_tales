# Keep very global helpers for the entire application
module ApplicationHelper
  # Generates the page's title header. By default, it will just write the app's
  # title, if anything else is provided by the view, rendered as content for
  # :title.
  #
  # @param [String] title to be added.
  # @return [String] complete page title.
  def page_title(title = nil)
    return t(:app_name) unless title
    content_for :title, ": #{title}" if title
  end

end
