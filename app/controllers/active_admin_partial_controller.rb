class ActiveAdminPartialController < AuthenticatedController
  def facility_privileges_partial
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    facility_projects = FacilityProject.includes(:facility, :project).where(project_id: project.id)
    @user_project_privileg = ProjectPrivilege.where(user_id: user.id, project_id: project.id).first
    @facility_privilege = FacilityPrivilege.new(user_id: user.id)
    render json: { html: render_to_string(template: "active_admin_partial/facility_privileges_partial", layout: false, :formats => [:html], locals: {facility_projects: facility_projects}) }
  end
end