class Api::V1::ContractDataController < AuthenticatedController

  def contract_client_types
    render json: ContractClientType.all.as_json(only: [:id, :name] )
  end

  def contract_categories
    render json: ContractCategory.all.as_json(only: [:id, :name] )
  end

  def contract_types
    render json: ContractType.all.as_json(only: [:id, :name] )
  end
  def contract_statuses
    render json: ContractStatus.all.as_json(only: [:id, :name] )
  end
  def contract_customeres
    render json: ContractCustomer.all.as_json(only: [:id, :name] )
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
  def contract_classification
    render json: ContractClassification.all.as_json(only: [:id, :name] )
  end

  def create_contract_category
    @contract_category = ContractCategory.new(contract_category_params)
    if @contract_category.save
      render json: @contract_category.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_category.errors.full_messages}
    end    
  end
  def contract_category_params
    params.require(:contract_category).permit(:id, :name)
  end

  def create_contract_client_type
    @contract_client_type = ContractClientType.new(contract_client_type_params)
    if @contract_client_type.save
      render json: @contract_client_type.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_client_type.errors.full_messages}
    end    
  end
  def contract_client_type_params
    params.require(:contract_client_type).permit(:id, :name)
  end

  def create_contract_type
    @contract_type = ContractType.new(contract_type_params)
    if @contract_type.save
      render json: @contract_type.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_type.errors.full_messages}
    end    
  end
  def contract_type_params
    params.require(:contract_type).permit(:id, :name)
  end

  def create_contract_status
    @contract_status = ContractStatus.new(contract_status_params)
    if @contract_status.save
      render json: @contract_status.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_status.errors.full_messages}
    end  
  end
  def contract_status_params
    params.require(:contract_status).permit(:id, :name)
  end


  def create_contract_customer
    @contract_customer = ContractCustomer.new(contract_customer_params)
    if @contract_customer.save
      render json: @contract_customer.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_customer.errors.full_messages}
    end
  end
  def contract_customer_params
    params.require(:contract_customer).permit(:id, :name)
  end
  

  def create_contract_vehicle
    @contract_vehicle = ContractVehicle.new(contract_vehicle_params)
    if @contract_vehicle.save
      render json: @contract_vehicle.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_vehicle.errors.full_messages}
    end
  end
  def contract_vehicle_params
    params.require(:contract_vehicle).permit(:id, :name)
  end

  def create_contract_vehicle_number
    @contract_vehicle_number = ContractVehicleNumber.new(contract_vehicle_number_params)
    if @contract_vehicle_number.save
      render json: @contract_vehicle_number.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_vehicle_number.errors.full_messages}
    end
  end
  def contract_vehicle_number_params
    params.require(:contract_vehicle_number).permit(:id, :name)
  end

  def create_contract_number
    @contract_number = ContractNumber.new(contract_number_params)
    if @contract_number.save
      render json: @contract_number.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_number.errors.full_messages}
    end
  end
  def contract_number_params
    params.require(:contract_number).permit(:id, :name)
  end

  def create_subcontract_number
    @subcontract_number = SubcontractNumber.new(subcontract_number_params)
    if @subcontract_number.save
      render json: @subcontract_number.as_json(only: [:id, :name] )
    else
      render json: {errors: @subcontract_number.errors.full_messages}
    end
  end
  def subcontract_number_params
    params.require(:subcontract_number).permit(:id, :name)
  end
  
  def create_contract_prime
    @contract_prime = ContractPrime.new(contract_prime_params)
    if @contract_prime.save
      render json: @contract_prime.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_prime.errors.full_messages}
    end
  end
  def contract_prime_params
    params.require(:contract_prime).permit(:id, :name)
  end

  def create_contract_current_pop
    @contract_current_pop = ContractCurrentPop.new(contract_current_pop_params)
    if @contract_current_pop.save
      render json: @contract_current_pop.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_current_pop.errors.full_messages}
    end
  end
  def contract_current_pop_params
    params.require(:contract_current_pop).permit(:id, :name)
  end

  def create_contract_classification
    @contract_classification = ContractClassification.new(contract_classification_params)
    if @contract_classification.save
      render json: @contract_classification.as_json(only: [:id, :name] )
    else
      render json: {errors: @contract_classification.errors.full_messages}
    end
  end
  def contract_classification_params
    params.require(:contract_classification).permit(:id, :name)
  end


end