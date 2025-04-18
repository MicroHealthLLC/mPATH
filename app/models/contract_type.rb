class ContractType < SortableRecord
  has_many :contracts
  belongs_to :user
  validates_presence_of :name
  
  def self.prime
    find_by(name: "Prime Contract")
  end
  def self.non_prime
    find_by(name: "Non Prime contract")
  end
  def self.prime_vehicles
    find_by(name: "Prime vehicles and ID IQs")
  end
  
end
