module Admin::BaseHelper
  
  def bool_label(bool)
    content_tag :label, bool, class: "label label-#{bool ? 'success' : 'default'}"
  end
  
  def link_to_bool(truth, target:, true_text:, false_text:)
    link_to truth ? true_text : false_text, target, method: :put, class: "btn btn-primary #{truth ? 'btn-danger' : 'btn-success'}"
  end
  
end