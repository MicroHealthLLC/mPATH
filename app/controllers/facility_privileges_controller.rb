class FacilityPrivilegesController < AuthenticatedController
  def facility_privileges_partial
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    facility_projects = FacilityProject.includes(:facility, :project).where(project_id: project.id)
    user_project_privileg = ProjectPrivilege.where(user_id: user.id, project_id: project.id).first
    
    facility_privilege = FacilityPrivilege.where(project_id: project.id, user_id: user.id).first
    if facility_privilege
      facility_project_ids = facility_privilege.facility_project_ids

      @facilities = project.facilities.where.not(id: facility_project_ids )
    else
      @facilities = project.facilities
    end

    local_hash = {project: project, facility_projects: facility_projects, user_project_privileg: user_project_privileg, index: params[:index]}
    render json: { html: render_to_string(template: "admin/facility_privileges/facility_privileges_partial", layout: false, :formats => [:html], locals: local_hash) }
  end

  def add_facility_privilege_form
    @user = User.find(params[:user_id])
    project = Project.find(params[:project_id])    
    render json: { html: render_to_string(template: "admin/facility_privileges/facility_privilege_form", layout: false, :formats => [:html], locals: {user: @user}) }
  end

end