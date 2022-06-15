class ContractProjectPoc < ApplicationRecord
  belongs_to :user
  before_save :filter_values

  def filter_values
    self.attributes.reject!{|k,v| v == nil || v == 'undefined' }
  end
end
