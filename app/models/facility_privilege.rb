class FacilityPrivilege < ApplicationRecord
  belongs_to :user
  belongs_to :facility_project
  belongs_to :facility, optional: true

  after_create :update_facility_id

  def update_facility_id
    unless self.facility_id.present?
      f = self.facility_project
      self.update(facility_id: f.facility_id)
    end
  end  
end
