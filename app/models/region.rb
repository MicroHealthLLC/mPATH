class Region < ApplicationRecord
  has_many :region_states, dependent: :destroy
  has_many :states, through: :region_states
  has_many :facilities

  validates :name, uniqueness: true
  validates :name, presence: true

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
