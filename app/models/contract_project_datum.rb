class ContractProjectDatum < ApplicationRecord
  belongs_to :contract_customer, optional: true
  belongs_to :contract_vehicle, optional: true
  belongs_to :contract_award_to, optional: true
  belongs_to :contract_naics, optional: true
  belongs_to :contract_award_type, optional: true
  belongs_to :contract_type, optional: true
  belongs_to :contract_current_pop, optional: true

  def to_json
    h = self.as_json
    h.merge!({contract_customer: contract_customer.as_json}) if contract_customer_id
    h.merge!({contract_vehicle: contract_vehicle.as_json}) if contract_vehicle_id
    h.merge!({contract_award_to: contract_award_to.as_json}) if contract_award_to_id
    h.merge!({contract_naics: contract_naics.as_json}) if contract_naics_id
    h.merge!({contract_award_type: contract_award_type.as_json}) if contract_award_type_id
    h.merge!({contract_type: contract_type.as_json}) if contract_type_id
    h.merge!({contract_current_pop: contract_current_pop.as_json}) if contract_current_pop_id
    h
  end

  def create_or_update_contract_project_data(params, user)
    contract_params = params.require(:contract).permit(Contract.params_to_permit)
    c_params = contract_params.dup
    if c_params[:id]
      contract_project_data = ContractProjectDatum.find(c_params[:id])
    else
      contract_project_data = self
    end
    contract_project_data.transaction do
      c_params.reject!{|k,v| v == 'undefined'}

      if c_params[:contract_customer_id] && !ContractCustomer.exists?(id: c_params[:contract_customer_id])
        c_params[:contract_customer_id] = ContractCustomer.create(name: c_params[:contract_customer_id]).id
      end
      if c_params[:contract_vehicle_id] && !ContractVehicle.exists?(id: c_params[:contract_vehicle_id])
        c_params[:contract_vehicle_id] = ContractVehicle.create(name: c_params[:contract_vehicle_id]).id
      end
      if c_params[:contract_award_to_id] && !ContractAwardTo.exists?(id: c_params[:contract_award_to_id])
        c_params[:contract_award_to_id] = ContractAwardTo.create(name: c_params[:contract_award_to_id]).id
      end
      if c_params[:contract_naics_id] && !ContractAwardTo.exists?(id: c_params[:contract_naics_id])
        c_params[:contract_naics_id] = ContractNaics.create(name: c_params[:contract_naics_id]).id
      end
      if c_params[:contract_award_type_id] && !ContractAwardType.exists?(id: c_params[:contract_award_type_id])
        c_params[:contract_award_type_id] = ContractAwardType.create(name: c_params[:contract_award_type_id]).id
      end
      if c_params[:contract_type_id] && !ContractType.exists?(id: c_params[:contract_type_id])
        c_params[:contract_type_id] = ContractType.create(name: c_params[:contract_type_id]).id
      end
      if c_params[:contract_current_pop_id] && !ContractCurrentPop.exists?(id: c_params[:contract_current_pop_id])
        c_params[:contract_current_pop_id] = ContractCurrentPop.create(name: c_params[:contract_current_pop_id]).id
      end

      # if c_params[:contract_sub_category_id] && !ContractSubCategory.exists?(id: c_params[:contract_sub_category_id])
      #   c_params[:contract_sub_category_id] = ContractSubCategory.create(name: c_params[:contract_sub_category_id]).id
      # end
      # if c_params[:contract_status_id] && !ContractStatus.exists?(id: c_params[:contract_status_id])
      #   c_params[:contract_status_id] = ContractStatus.create(name: c_params[:contract_status_id]).id
      # end
      # if c_params[:contract_vehicle_number_id] && !ContractVehicleNumber.exists?(id: c_params[:contract_vehicle_number_id])
      #   c_params[:contract_vehicle_number_id] = ContractVehicleNumber.create(name: c_params[:contract_vehicle_number_id]).id
      # end
      # if c_params[:contract_number_id] && !ContractNumber.exists?(id: c_params[:contract_number_id])
      #   c_params[:contract_number_id] = ContractNumber.create(name: c_params[:contract_number_id]).id
      # end
      # if c_params[:subcontract_number_id] && !SubcontractNumber.exists?(id: c_params[:subcontract_number_id])
      #   c_params[:subcontract_number_id] = SubcontractNumber.create(name: c_params[:subcontract_number_id]).id
      # end
      # if c_params[:contract_prime_id] && !ContractPrime.exists?(id: c_params[:contract_prime_id])
      #   c_params[:contract_prime_id] = ContractPrime.create(name: c_params[:contract_prime_id]).id
      # end
      # if c_params[:contract_classification_id] && !ContractClassification.exists?(id: c_params[:contract_classification_id])
      #   c_params[:contract_classification_id] = ContractClassification.create(name: c_params[:contract_classification_id]).id
      # end
      # if c_params[:contract_client_type_id] && !ContractClientType.exists?(id: c_params[:contract_client_type_id])
      #   c_params[:contract_client_type_id] = ContractClientType.create(name: c_params[:contract_client_type_id]).id
      # end
      # if c_params[:contract_category_id] && !ContractCategory.exists?(id: c_params[:contract_category_id])
      #   c_params[:contract_category_id] = ContractCategory.create(name: c_params[:contract_category_id]).id
      # end
      contract.attributes = c_params
      contract.user_id = user.id
      contract.save
    end
    # if params[:facility_group_name]
    #   contract.contract_facility_group.update(name: params[:facility_group_name])
    # end
    contract
  end

end
