class Api::V1::ProgramSettings::ProjectsController < AuthenticatedController 

  before_action :check_permission

  def check_permission
    program_id = params[:id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil
    if ["show" ].include?(params[:action]) 
      action = "R"
    elsif ["add_contract", "add_contract_vehicle" ].include?(params[:action]) 
      action = "W"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id,action,  RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES)
  end

  def show
    @project = current_user.authorized_programs.find_by(id: params[:id])
    unless @project.nil?
    render json: {project: @project.build_json_response(current_user, response_for: 'program_settings')}, status: 200
     else
      render json: {error: "Project not found"}, status: :not_found
    end
  end

  def add_contract
    contract_project_data = ContractProjectDatum.find(params[:contract_id])
    project = Project.find(params[:id])
    project_contract = ProjectContract.new(project_id: project.id, contract_project_datum_id: contract_project_data.id)
    if project_contract.save
      render json: {message: "Contract added successfully"}
    else
      render json: {error: project_contract.errors.full_messages}, status: 406
    end
  end

  def add_contract_vehicle
    contract_vehicle = ContractVehicle.find(params[:contract_vehicle_id])
    project = Project.find(params[:id])
    project_contract_vehicle = ProjectContractVehicle.new(project_id: project.id, contract_vehicle_id: contract_vehicle.id)
    if project_contract_vehicle.save
      render json: {message: "Contract Vehicle is added successfully"}
    else
      render json: {error: project_contract_vehicle.errors.full_messages}, status: 406
    end
  end
end
