class ContractCustomer < ApplicationRecord
  has_many :contracts
  belongs_to :user
  validates_presence_of :name
end
