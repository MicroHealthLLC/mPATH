class Api::V1::ContractVehiclesController < AuthenticatedController

  def index
    contract_vehicles = ContractVehicle.all.map(&:to_json)
    render json: {contract_vehicles: contract_vehicles}
  end

  def create
    contract_vehicle = ContractVehicle.new(contract_vehicle_params)
    if contract_vehicle.save
      render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicles.errors.full_message}, status: 406
    end
  end

  def update
    contract_vehicle = ContractVehicle.find(params[:id])
    if contract_vehicle.update(contract_vehicle_params)
      render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicles.errors.full_message}, status: 406
    end
  end

  def destroy
    contract_vehicle = ContractVehicle.find(params[:id])
    if contract_vehicle.destroy
      render json: {contract_vehicle: contract_vehicle}
    else
      render json: {errors: contract_vehicles.errors.full_message}, status: 406
    end
  end

  private
  def contract_vehicle_params
    params[:vehicle].permit(:name, :vehicle_number, :full_name, :conctract_sub_category_id, :contract_agency_id, :vehicle_type_id, :contract_number, :ceiling, :base_period_start, :base_period_end, :option_period_start, :option_period_end)
  end
end