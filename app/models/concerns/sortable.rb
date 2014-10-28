module Sortable
  extend ActiveSupport::Concern
  
  included do

    def self.sortable(*args)
      raise ArgumentError if args.blank?
      valid_columns = args
      valid_orders = %w[asc desc]

      scope :sorty, lambda { |params|
        column = params[:column]
        order = params[:order] || valid_orders.first.to_sym
        return unless column.present? && valid_columns.include?(column.to_sym) && valid_orders.include?(order.to_s)
        order([column, order].join(' '))
      }
    end
  
  end
  
end