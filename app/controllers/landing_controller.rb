class LandingController < AuthenticatedController
  def index
    # Adding join is preventing eager loading
    project_ids = ProjectUser.where(user_id: current_user.id).map(&:project_id).compact.uniq
    @active_projects = Project.includes(:facilities, facility_projects: [:tasks, :status]).where(id: project_ids).active
  end
end
