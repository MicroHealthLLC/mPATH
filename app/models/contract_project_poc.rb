class ContractProjectPoc < ApplicationRecord
  belongs_to :user
  before_save :filter_values
  validates :name,presence: true
  # validates :email,presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  # validate :number_check
  # poc_type fields: 'contract_office', government, program_manager
  
  CONTRACT_OFFICE_POC_TYPE = 'contract_office'
  GOVERNMENT_POC_TYPE = 'government'
  PROGRAM_MANAGER_POC_TYPE = 'program_manager'

  def filter_values
    self.attributes.reject!{|k,v| v == 'undefined' }
  end

  def number_check
    if mobile_number.blank? && work_number.blank?
      errors.add(:base, "Mobile number or work number is required")
      return false
    end
  end

end
