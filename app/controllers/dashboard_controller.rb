class DashboardController < AuthenticatedController
  layout "portfolio_viewer", only: [:portfolio]
  
  def index
    # project_ids = ProjectUser.where(user_id: current_user.id).map(&:project_id).compact.uniq
    # @active_projects = Project.includes(:facilities, facility_projects: [:tasks, :status]).where(id: project_ids).active
    @preferences = current_user.settings(:preferences)
    project_ids = ProjectUser.where(user_id: current_user.id).map(&:project_id).compact.uniq
    @active_projects = Project.includes(:facilities, facility_projects: [:tasks, :status, :facility]).where(id: project_ids).active
    @facility_projects_hash = FacilityProject.where(project_id: @active_projects.map(&:id)).group_by(&:project_id)
    # @facilities = Facility.where(id: @facility_projects_hash.values.flatten.map(&:facility_id)).active
    # @facility_projects_hash.each do |project_id, facility_projects|
    #   fids = facility_projects.map(&:facility_id).compact.uniq
    #   f = @facilities.select{|ff| fids.include?(ff.id) }
    #   @facility_projects_hash[project_id] = f  
    # end
  end

  def portfolio
    if !current_user.projects.active.any?
      redirect_to root_path
    end
  end

end
