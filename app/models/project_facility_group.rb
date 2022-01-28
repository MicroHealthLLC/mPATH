class ProjectFacilityGroup < ApplicationRecord
  belongs_to :project
  belongs_to :project_group, class_name: "FacilityGroup", foreign_key: 'facility_group_id'
end
