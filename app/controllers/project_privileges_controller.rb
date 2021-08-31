# NOTE: This controller is used for Admin
class ProjectPrivilegesController < AuthenticatedController
  def load_form
    if params[:user_id]
      @user = User.find(params[:user_id])
      @project_ids = @user.project_privileges.map(&:project_ids).flatten.uniq
      @projects_to_select = @user.projects.active.where.not(id: @project_ids)
    else
      @user = User.new
      @projects_to_select = Project.active
    end
    projects_avaialble = @projects_to_select.any?
    render json: { 
        html: render_to_string(template: "admin/project_privileges/form", layout: false, :formats => [:html], locals: {user: @user}),
        projects_avaialble: projects_avaialble
      }
  end
end