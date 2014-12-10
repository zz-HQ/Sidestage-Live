module PageableResource
  extend ActiveSupport::Concern
  
  included do
    helper_method  :next_resource, :prev_resource
  end
  
  protected

  def next_resource(rotate=true)
    if collection.arel.orders.present?
      field = collection.arel.orders.first.split(" ").first
      @next_resource ||= collection.where("#{resource.class.table_name}.#{field} > ?", resource.send(field)).first
    else
      @next_resource ||= collection.where("#{resource.class.table_name}.id > ?", resource.id).order("id ASC").first      
    end
    @next_resource ||= collection.first if rotate == true #rotate back to first item
  end

  def prev_resource
    if collection.arel.orders.present?
      field = collection.arel.orders.first.split(" ").first
      @prev_resource ||= collection.where("#{resource.class.table_name}.#{field} < ?", resource.send(field)).last
    else
      @prev_resource ||= collection.where("#{resource.class.table_name}.id < ?", resource.id).order("#{resource.class.table_name}.id DESC").first
    end
  end
  
end