class ContractPrivilegesController < ApplicationController
  def contract_privileges_partial
    project = Project.find(params[:project_id])
    if params[:user_id].present?
      user = User.find(params[:user_id])
    else
      user = User.new
    end

    contracts = Contract.includes(:project).where(project_id: project.id)
    user_project_privileg = ProjectPrivilege.where(user_id: user.id).select{|s| s.project_ids.include?(project.id.to_s) }.first
    contract_privileges = ContractPrivilege.where(project_id: project.id, user_id: user.id)
    if contract_privileges
      contract_ids = [] 
      contract_privileges.each{|fp| contract_ids << fp.contract_ids }
      
      contract_ids = contract_ids.flatten.uniq

      @contracts = project.contracts.where.not(id: contract_ids )
    else
      @contracts = project.contracts
    end

    local_hash = {project: project, contracts: contracts, user_project_privileg: user_project_privileg, index: params[:index]}
    render json: { html: render_to_string(template: "admin/contract_privileges/contract_privileges_partial", layout: false, :formats => [:html], locals: local_hash) }
  end

  def add_contract_privilege_form
    if params[:user_id]
      @user = User.find(params[:user_id])
      @active_projects = @user.projects.active
    else
      @user = User.new
      @active_projects = Project.where(id: params[:program_ids])
    end
    render json: { html: render_to_string(template: "admin/contract_privileges/contract_privilege_form", layout: false, :formats => [:html], locals: {user: @user}) }
  end

end
