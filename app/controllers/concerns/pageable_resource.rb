module PageableResource
  extend ActiveSupport::Concern
  
  included do
    helper_method  :next_resource, :prev_resource, :next_page, :current_page
  end
  
  protected

  def next_resource
    if resources.arel.orders.present?
      field = resources.arel.orders.first.split(" ").first
      @next_resource ||= resources.where("#{field} > ?", resource.send(field)).first
    else
      @next_resource ||= resources.where("id > ?", resource.id).order("id ASC").first      
    end
  end

  def prev_resource
    if resources.arel.orders.present?
      field = resources.arel.orders.first.split(" ").first
      @prev_resource ||= resources.where("#{field} < ?", resource.send(field)).last
    else
      @prev_resource ||= resources.where("id < ?", resource.id).order("id DESC").first
    end
  end
  
  def resources
    end_of_association_chain
  end
  
end