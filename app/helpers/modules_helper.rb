module ModulesHelper

  def nice_select(select)
    raise "I need a select tag" if select.blank?
    label = content_tag(:span, "label", class: "select-label")
    arrow = content_tag(:span, nil, class: "select-arrow")
    select_content = label + arrow + select
    content_tag(:div, select_content, class: "nice-select")
  end
  
end
