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

  def breadcrumbs
    return unless content_for?(:breadcrumbs)
    
    # Parse the breadcrumb data from the content_for string
    breadcrumb_data = eval(content_for(:breadcrumbs))
    
    content_tag :div, class: "breadcrumb-container", style: "background: var(--gray-50); border-bottom: 1px solid var(--gray-200);" do
      content_tag :div, class: "container", style: "padding: 0.5rem 0;" do
        content_tag :nav, style: "font-size: 0.875rem; color: var(--gray-500);" do
          breadcrumb_data.map.with_index do |item, index|
            if item[:url] && index < breadcrumb_data.length - 1
              # Clickable link (not the last item)
              link_to(item[:text], item[:url], style: "color: var(--gray-500); text-decoration: none;") +
              content_tag(:span, " / ", style: "margin: 0 0.5rem; color: var(--gray-400);")
            else
              # Current page (last item) - not clickable
              content_tag(:span, item[:text], style: "color: var(--gray-700); font-weight: 500;")
            end
          end.join.html_safe
        end
      end
    end
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