class SortableRecord < ApplicationRecord
  self.abstract_class = true

  protected
  def self.sort_order?
    sort = Sort.find_by(relation: self.to_s.pluralize.underscore)
    return nil if sort.nil?
    "#{sort.column}_#{sort.order}"
  end

  def self.order_humanize
    so = self.sort_order?
    so.humanize.downcase if so
  end
end
