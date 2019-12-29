class Facility < ApplicationRecord
  belongs_to :region

  def as_json(options=nil)
    json = super(options)
    json.merge(
      region: self.region.as_json
    ).as_json
  end
end
