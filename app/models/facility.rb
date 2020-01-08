class Facility < ApplicationRecord
  belongs_to :region
  belongs_to :creator, class_name: "User"
  validates :latlng, uniqueness: true

  def as_json(options=nil)
    json = super(options)
    json.merge(
      region: self.region.as_json,
      creator: self.creator.as_json
    ).as_json
  end
end
