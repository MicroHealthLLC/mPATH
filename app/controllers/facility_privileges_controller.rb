# NOTE: This controller is used for Admin
class FacilityPrivilegesController < AuthenticatedController
  def facility_privileges_partial
    project = Project.find(params[:project_id])
    if params[:user_id].present?
      user = User.find(params[:user_id])
    else
      user = User.new
    end

    facility_projects = FacilityProject.includes(:facility, :project).where(project_id: project.id)
    user_project_privileg = ProjectPrivilege.where(user_id: user.id).select{|s| s.project_ids.include?(project.id.to_s) }.first
    facility_privileges = FacilityPrivilege.where(project_id: project.id, user_id: user.id)
    if facility_privileges
      facility_project_ids = [] 
      facility_privileges.each{|fp| facility_project_ids << fp.facility_project_ids }
      
      facility_project_ids = facility_project_ids.flatten.uniq

      @facilities = project.facilities.where.not(id: facility_project_ids )
    else
      @facilities = project.facilities
    end

    local_hash = {project: project, facility_projects: facility_projects, user_project_privileg: user_project_privileg, index: params[:index]}
    render json: { html: render_to_string(template: "admin/facility_privileges/facility_privileges_partial", layout: false, :formats => [:html], locals: local_hash) }
  end

  def add_facility_privilege_form
    if params[:user_id]
      @user = User.find(params[:user_id])
      @active_projects = @user.projects.active
    else
      @user = User.new
      @active_projects = Project.where(id: params[:program_ids])
    end
    render json: { html: render_to_string(template: "admin/facility_privileges/facility_privilege_form", layout: false, :formats => [:html], locals: {user: @user}) }
  end

end