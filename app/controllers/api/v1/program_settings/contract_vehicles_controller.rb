class Api::V1::ProgramSettings::ContractVehiclesController < AuthenticatedController
  before_action :check_permission
  before_action :set_project

  def check_permission
    program_id = params[:project_id]

    raise(CanCan::AccessDenied) if !program_id
    action = nil

    if ["index", "show" ].include?(params[:action]) 
      action = "R"
    elsif ["create", "update"].include?(params[:action]) 
      action = "W"
    elsif ["destroy"].include?(params[:action]) 
      action = "D"
    end

    raise(CanCan::AccessDenied) if !current_user.has_program_setting_role?(program_id, action, RolePrivilege::PROGRAM_SETTING_CONTRACTS)
  end

  def index

    project_contract_vehicles = @project.project_contract_vehicles.includes( [{ contract_vehicle: ContractVehicle.preload_array}, :facility_group ])
    c = []
    project_contract_vehicles.in_batches do |_project_contract_vehicles|
      c += _project_contract_vehicles.map{|pc| pc.to_json }
    end
    render json: {contract_vehicles: c, total_count: c.size}
  end

  def show
    project_contract_vehicle = @project.project_contract_vehicles.find(params[:id])
    if project_contract_vehicle
      render json: {contract_vehicle: project_contract_vehicle.to_json}
    else
      render json: {errors: "Can't finding contract vehicle!"}, staus: 406
    end
  end
  
  def update
    project_contract_vehicle = @project.project_contract_vehicles.find(params[:id])

    if project_contract_vehicle && project_contract_vehicle.update(project_contract_vehicle_params)
      render json: {message: "Successfully updated contract vehicle "}
    else
      render json: {errors: project_contract_vehicle.errors.full_messages}, staus: 406
    end
  end

  def destroy
    project_contract_vehicle = @project.project_contract_vehicles.find(params[:id])

    if project_contract_vehicle && project_contract_vehicle.destroy
      render json: {message: "Successfully removed association!"}
    else
      render json: {errors: "Error removing association!"}, staus: 406
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_contract_vehicle_params
    params.require(:project_contract_vehicle).permit(:facility_group_id)
  end


end