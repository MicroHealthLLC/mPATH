class Api::V1::Portfolio::ContractVehiclesController < AuthenticatedController
  before_action :check_contract_read_permission, only: [:index]
  before_action :check_contract_write_permission, only: [:create, :update, :add_project]
  before_action :check_contract_delete_permission, only: [:destroy]
  
  def check_contract_read_permission
    raise CanCan::AccessDenied if !current_user.can_access_contract_data?
  end
  def check_contract_write_permission
    raise CanCan::AccessDenied if !current_user.can_write_contract_data?
  end
  def check_contract_delete_permission
    raise CanCan::AccessDenied if !current_user.can_delete_contract_data?
  end

  def index
    contract_vehicles = ContractVehicle.all.map(&:to_json)
    render json: {contract_vehicles: contract_vehicles}
  end

  def create
    contract_vehicle = ContractVehicle.new.create_or_update_contract_vehicle(params, current_user)
    if !contract_vehicle.errors.any?
      render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicle.errors.full_messages}, status: 406
    end
  end

  def update
    contract_vehicle = ContractVehicle.new.create_or_update_contract_vehicle(params, current_user)
    if !contract_vehicle.errors.any?
        render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicle.errors.full_messages}, status: 406
    end
  end

  def destroy
    contract_vehicle = ContractVehicle.find(params[:id])
    if contract_vehicle.destroy
      render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicles.errors.full_messages}, status: 406
    end
  end

  private
  def contract_vehicle_params
    params.required(:contract_vehicle).permit(:name, :full_name, :contract_agency_id, :contract_vehicle_type_id, :contract_number, :ceiling, :base_period_start, :base_period_end, :option_period_start, :option_period_end, :contract_sub_category_id, :caf_fees)
  end
end