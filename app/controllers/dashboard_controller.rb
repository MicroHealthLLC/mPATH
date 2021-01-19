class DashboardController < AuthenticatedController
  def index
    @active_projects = current_user.projects.active
    @facility_projects_hash = FacilityProject.where(project_id: @active_projects.map(&:id)).group_by(&:project_id)
  end
end
