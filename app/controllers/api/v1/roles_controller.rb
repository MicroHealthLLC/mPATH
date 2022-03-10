class Api::V1::RolesController < ApplicationController
  def index
    project = Project.find(params[:project_id])
    roles = project.roles
    render json: {roles: roles}
  end

  def create
    role = Role.new(roles_params)
    if role.save
      render json: {message: "Role created successfully"}
    else
      render json: {errors: role.errors.full_messages}
    end
  end

  def update

  end

  def destroy
    
  end

  private
  def roles_params
    params.require(:role).permit!(:id, :name, :project_id)
  end
end
