class ContractProjectPoc < ApplicationRecord
  belongs_to :user
  before_save :filter_values
  validates :email,presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :work_number,presence: true
  validates :mobile_number, presence: true
  def filter_values
    self.attributes.reject!{|k,v| v == 'undefined' }
  end
end
