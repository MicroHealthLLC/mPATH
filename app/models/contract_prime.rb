class ContractPrime < ApplicationRecord
  has_many :contracts
  validates_presence_of :name
end
