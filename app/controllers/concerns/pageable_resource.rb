module PageableResource
  extend ActiveSupport::Concern
  
  included do
    helper_method  :next_resource, :prev_resource, :next_page, :current_page
  end
  
  protected

  def next_resource(rotate=true)
    if resources.arel.orders.present?
      field = resources.arel.orders.first.split(" ").first
      @next_resource ||= resources.where("#{resource.class.table_name}.#{field} > ?", resource.send(field)).first
    else
      @next_resource ||= resources.where("#{resource.class.table_name}.id > ?", resource.id).order("id ASC").first      
    end
    @next_resource ||= resources.first if rotate == true #rotate back to first item
  end

  def prev_resource
    if resources.arel.orders.present?
      field = resources.arel.orders.first.split(" ").first
      @prev_resource ||= resources.where("#{resource.class.table_name}.#{field} < ?", resource.send(field)).last
    else
      @prev_resource ||= resources.where("#{resource.class.table_name}.id < ?", resource.id).order("#{resource.class.table_name}.id DESC").first
    end
  end
  
  def resources
    end_of_association_chain
  end
  
end