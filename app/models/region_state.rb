class RegionState < ApplicationRecord
  belongs_to :facility_group
  belongs_to :state
end
