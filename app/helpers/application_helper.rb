module ApplicationHelper
  def header_categories
    categories = Category.all
    return categories
  end
end
