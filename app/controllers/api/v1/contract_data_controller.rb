class Api::V1::ContractDataController < AuthenticatedController
  def contract_types
    render json: ContractType.all.as_json(only: [:id, :name] )
  end
  def contract_statuses
    render json: ContractStatus.all.as_json(only: [:id, :name] )
  end
  def contract_name_customeres
    render json: ContractNameCustomer.all.as_json(only: [:id, :name] )
  end
  def contract_vehicles
    render json: ContractVehicle.all.as_json(only: [:id, :name] )
  end
  def contract_vehicle_number
    render json: ContractVehicleNumber.all.as_json(only: [:id, :name] )
  end
  def contract_number
    render json: ContractNumber.all.as_json(only: [:id, :name] )
  end
  def subcontract_number
    render json: SubcontractNumber.all.as_json(only: [:id, :name] )
  end
  def contract_prime
    render json: ContractPrime.all.as_json(only: [:id, :name] )
  end
  def contract_current_pop
    render json: ContractCurrentPop.all.as_json(only: [:id, :name] )
  end
end