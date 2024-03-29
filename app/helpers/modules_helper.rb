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

    	content += content_tag(:span, "#{Review.human_attribute_name(:rating)}:") if options[:label].present?

      5.times do |i|
        klass = "fa fa-star rating-star rating-off"
        content += content_tag(:i, nil, class: klass)
      end

      content += options[:f].input :rate, as: :hidden, required: true
      
      content.html_safe
    end
  end

  def read_more(text, length = 300)
    if text.to_s.size > length
      text = "#{truncate(strip_tags(text), length: length)}"
    end
    text
  end

  def home_or_profile_page?
    if action_name == 'homepage' || action_name == 'preview' || controller_name == 'artists' && action_name == 'show'
      true
    end
  end
  
  def country_code_select(form)
    nice_select form.input(:mobile_nr_country_code, collection: CALLING_CODES.collect { |k,v| [v,k] }, include_blank: false, label: false)
  end
  
  def country_code_field(form)
    form.object.mobile_nr_country_code.present? ? "+#{form.object.mobile_nr_country_code}" : "+1"
  end
  
end
