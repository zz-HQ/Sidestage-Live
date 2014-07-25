module Admin::BaseHelper
  
  def bool_label(bool)
    content_tag :label, bool_text(bool), class: "label label-#{bool ? 'success' : 'danger'}"
  end
  
  def bool_text(bool)
    bool ? "Yes" : "No"
  end
  
  def link_to_bool(truth, target:, true_text:, false_text:)
    link_to truth ? true_text : false_text, target, method: :put, class: "btn btn-primary #{truth ? 'btn-danger' : 'btn-success'}"
  end
  
end