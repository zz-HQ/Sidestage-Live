module ModulesHelper

  def nice_select(select, options = {})
    raise "I need a select tag" if select.blank?

    klass = "nice-select"
    klass += " small" if options[:small].present?

    label_value = content_tag(:span, nil, class: "select-label-value")
    #arrow = content_tag(:span, nil, class: "select-arrow")
    arrow = content_tag(:i, nil, class: "fa fa-angle-down select-arrow")
    label = content_tag(:span, (label_value + arrow), class: "select-label")
    select_content = label + select
    content_tag(:div, select_content, class: klass)
  end

  def star_rating(options = {})
    klass = "star-rating"
    klass += " star-rating-editable" if options[:editable].present?
    content_tag(:div, class: klass) do

    	content = ''

    	content += content_tag(:span, "Rating:") if options[:label].present?

      5.times do |i|
        klass = "fa fa-star rating-star rating-off"
        content += content_tag(:i, nil, class: klass)
      end

      content += options[:f].input :rate, as: :hidden, required: true
      
      content.html_safe
    end
  end
  
end
