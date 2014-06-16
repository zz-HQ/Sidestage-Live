module Sortable
  extend ActiveSupport::Concern
  
  included do

    def self.sortable(column = :id, order = :asc)
      @options = { column: column.to_s, order: order.to_s }

      valid_orders = %w[asc desc]
      valid_columns = begin 
                        columns.map(&:name)
                      rescue 
                        []
                      end
      valid_columns += reflections.map{|r| r[1].options[:polymorphic] === true ? nil : r[1].class_name.constantize.columns.map{|c| "#{r[0]}.#{c.name}"}}.flatten

      # Check arguments
      raise ArgumentError unless valid_columns.blank? || valid_columns.include?(@options[:column])
      raise ArgumentError unless valid_columns.blank? || valid_orders.include?(@options[:order])

      # Define named scope
      scope :sorty, lambda { |params|
        column = params[:column]
        order = params[:order]

        return unless valid_columns.blank? || (valid_columns.include?(column) && valid_orders.include?(order))
        Rails.logger.info "###########################"
        Rails.logger.info params.inspect
        Rails.logger.info "###########################"
        # Load in association
        if column.include?('.')
          # Split column into reflection name and column
          reflection_name, column = column.split('.')
          reflection_name = reflection_name.to_sym

          # Calculate the new column name
          table = reflections[reflection_name].table_name
          column = "#{table}.#{column}"

          # Add the association
          associations = [reflection_name]
        end

        # Return order hash
        order([column, order].delete_if(&:blank?).join(' '))
      }
    end
  
  end
  
end