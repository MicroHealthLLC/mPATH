class FacilityGroup < ApplicationRecord
  has_many :facilities
  has_many :facility_projects, through: :facilities

  validates :name, uniqueness: true
  validates :name, presence: true

  enum status: [:inactive, :active].freeze

  def as_json(options=nil)
    json = super(options)
    json.merge(
      facilities: self.facility_projects.as_json,
      facility_count: self.facilities.count
    ).as_json
  end
end
