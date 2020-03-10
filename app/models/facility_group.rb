class FacilityGroup < ApplicationRecord
  has_many :facilities

  validates :name, uniqueness: true
  validates :name, presence: true

  enum status: [:inactive, :active]

  def as_json(options=nil)
    json = super(options)
    json.merge(
      facilities: self.facilities.as_json,
      facility_count: self.facilities.count
    ).as_json
  end
end
