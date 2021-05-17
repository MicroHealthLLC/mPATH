class ProjectPrivilegesController < AuthenticatedController
  def load_form
    @user = User.find(params[:user_id])
    @project_ids = @user.project_privileges.map(&:project_ids).flatten.uniq

    @projects_to_select = @user.projects.active.where.not(id: @project_ids)
    render json: { html: render_to_string(template: "admin/project_privileges/form", layout: false, :formats => [:html], locals: {user: @user}) }
  end
end