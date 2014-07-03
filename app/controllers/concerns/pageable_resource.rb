module PageableResource
  extend ActiveSupport::Concern
  
  included do
    helper_method  :next_resource, :prev_resource, :next_page, :current_page
  end
  
  protected

  def next_resource
    @next_resource ||= resources.where("id > ?", resource.id).order("id ASC").first
  end

  def prev_resource
    @prev_resource ||= resources.where("id < ?", resource.id).order("id DESC").first
  end
  
  # def next_resource
  #   @next_resource ||= resources.paginate(page: next_page, per_page: 1).first
  # end
  # 
  # def prev_resource
  #   return if prev_page < 1
  #   @prev_resource ||= resources.paginate(page: prev_page, per_page: 1).first
  # end
  
  def resource_page
    1
  end

  def current_page
    params[:page].to_i == 0 ? resource_page : params[:page].to_i
  end

  def prev_page
    current_page - 1
  end
  
  def next_page
    current_page + 1
  end
    
  def resources
    end_of_association_chain
  end
  
end