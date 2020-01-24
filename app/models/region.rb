class Region < ApplicationRecord
  has_many :states
  has_many :facilities
  validates :name, uniqueness: true
  enum status: [:inactive, :active]
  enum region_type: [:region, :country, :state]

  def as_json(options=nil)
    json = super(options)
    json.merge(
      states: self.states.as_json,
      facility_count: self.facilities.count
    ).as_json
  end
  
end
