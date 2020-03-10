class FacilityProject < ApplicationRecord
  belongs_to :facility
  belongs_to :project
  validates_uniqueness_of :facility_id, :project_id
end
