module ModulesHelper

  def nice_select(select)
    raise "I need a select tag" if select.blank?
    label_value = content_tag(:span, "label", class: "select-label-value")
    #arrow = content_tag(:span, nil, class: "select-arrow")
    arrow = content_tag(:i, nil, class: "fa fa-angle-down select-arrow")
    label = content_tag(:span, (label_value + arrow), class: "select-label")
    select_content = label + select
    content_tag(:div, select_content, class: "nice-select")
  end
  
end
