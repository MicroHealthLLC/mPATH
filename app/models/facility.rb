class Facility < ApplicationRecord
  belongs_to :region
  belongs_to :creator, class_name: "User"
  belongs_to :project
  enum status: [:pending, :completed]

  # geocoded_by :address, latitude: :lat, longitude: :lng
  # after_validation :geocode, if: lambda { |f| f.address_changed? }

  def as_json(options=nil)
    json = super(options)
    json.merge(
      creator: self.creator.as_json
    ).as_json
  end
end
