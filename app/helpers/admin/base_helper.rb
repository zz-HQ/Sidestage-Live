module Admin::BaseHelper
  
  def bool_label(bool)
    content_tag :label, bool_text(bool), class: "label label-#{bool ? 'success' : 'danger'}"
  end
  
  def bool_text(bool)
    bool ? "Yes" : "No"
  end
  
  def link_to_bool(truth, target=nil, true_text=nil, false_text=nil)
    link_to truth ? true_text : false_text, target, method: :put, class: "btn btn-primary #{truth ? 'btn-danger' : 'btn-success'}"
  end
  
  def error_messages_for(resource, options={})
    return "" if resource.nil? || resource.errors.empty?
    
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    default_options = { full_messages: true, sentence: sentence }
    options = default_options.merge(options)
    
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = "<div id='error-explanation'><h2 class='light'>#{options[:sentence]}</h2>"
    html << "<ul>#{messages}</ul>" if options[:full_messages]
    html << "</div>"
    
    html.html_safe
  end
  
end