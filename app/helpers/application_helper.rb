module ApplicationHelper
  def industry_card_icon(category_name, options = {})
    file_name = convert_to_filename(category_name)
    icon_path = "icons/categories/#{file_name}-icon.svg"
    image_tag(icon_path, options.merge(class: "industry-icon"))
  end

  def industry_card_label(category_name, options = {})
    file_name = convert_to_filename(category_name)
    label_path = "icons/categories/#{file_name}-label.svg"
    image_tag(label_path, options.merge(class: "industry-label"))
  end

  private

  def convert_to_filename(category_name)
    # Convert category names to file-safe names
    case category_name.downcase
    when 'lab automation'
      'lab-automation'
    when 'personal care'
      'personal-care'
    when 'pharma healthcare'
      'pharma-healthcare'
    when 'tissue hygiene'
      'tissue-hygiene'
    when 'e-commerce'
      'e-commerce'
    else
      category_name.downcase.gsub(/\s+/, '-')
    end
  end
end 