class ProjectFacilityGroup < ApplicationRecord
  belongs_to :project
  belongs_to :project_group, class_name: "FacilityGroup", foreign_key: 'facility_group_id'
  
  validates :facility_group_id, :uniqueness => {:scope => :project_id}

  after_destroy :apply_unassigned_to_resource

  def apply_unassigned_to_resource
    
    facility_projects_group = self.project_group.facility_projects.includes(:project).where(project_id: self.project_id).group_by{|fp| fp.project }
    project_contract_group = self.project_group.project_contracts.includes(:project).where(project_id: self.project_id).group_by{|fp| fp.project }
    project_contract_vehicles = self.project_group.project_contract_vehicles.includes(:project).where(project_id: self.project_id).group_by{|fp| fp.project }

    facility_projects_group.each do |project, facility_projects|
      unassigned = project.default_facility_group
      FacilityProject.where(id: facility_projects.map(&:id) ).update_all(facility_group_id: unassigned.id)
    end
    
    project_contract_group.each do |project, project_contracts|
      unassigned = project.default_facility_group
      ProjectContract.where(id: project_contracts.map(&:id) ).update_all(facility_group_id: unassigned.id)
    end

    project_contract_vehicles.each do |project, project_contract_vehicles|
      unassigned = project.default_facility_group
      ProjectContractVehicle.where(id: project_contract_vehicles.map(&:id) ).update_all(facility_group_id: unassigned.id)
    end

  end

end
