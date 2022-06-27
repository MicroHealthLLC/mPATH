class ContractProjectPoc < ApplicationRecord
  belongs_to :user
  before_save :filter_values
  validates :email,presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validate :number_check
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
