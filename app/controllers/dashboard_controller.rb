class DashboardController < AuthenticatedController
  def index
    project_ids = ProjectUser.where(user_id: current_user.id).map(&:project_id).compact.uniq
    @active_projects = Project.includes(:facilities, facility_projects: [:tasks, :status]).where(id: project_ids).active
  end
end
