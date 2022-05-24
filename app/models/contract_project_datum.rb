class ContractProjectDatum < ApplicationRecord
  belongs_to :contract_customer, optional: true
  belongs_to :contract_vehicle, optional: true
  belongs_to :contract_award_to, optional: true
  belongs_to :contract_naic, optional: true
  belongs_to :contract_award_type, optional: true
  belongs_to :contract_type, optional: true
  belongs_to :contract_current_pop, optional: true
  belongs_to :contract_pop, optional: true
  belongs_to :user, optional: true
  
  def to_json
    h = self.as_json
    h.merge!({contract_customer: contract_customer.as_json}) if contract_customer_id
    h.merge!({contract_vehicle: contract_vehicle.as_json}) if contract_vehicle_id
    h.merge!({contract_award_to: contract_award_to.as_json}) if contract_award_to_id
    h.merge!({contract_naic: contract_naic.as_json}) if contract_naic_id
    h.merge!({contract_award_type: contract_award_type.as_json}) if contract_award_type_id
    h.merge!({contract_type: contract_type.as_json}) if contract_type_id
    h.merge!({contract_current_pop: contract_current_pop.as_json}) if contract_current_pop_id
    h
  end
  def self.params_to_permit
    [
      :id, :contract_vehicle_id, :contract_award_type_id, :name, :charge_code, :contract_customer_id, :contract_award_to_id, :contract_type_id, :prime_or_sub, :contract_start_date, :contract_end_date, :total_contract_value, :contract_pops, :contract_current_pop_id, :contract_current_pop_start_date, :contract_current_pop_end_date, :total_founded_value, :billings_to_date, :comments, :pm_contract_poc_id, :gov_contract_poc_id, :co_contract_poc_id, :contract_naic_id, :contract_pop_id, :number
    ]
  end

  def expired?
    contract_end_date < DateTime.now
  end

  def create_or_update_contract_project_data(params, user)
    contract_params = params.require(:contract_project_data).permit(ContractProjectDatum.params_to_permit)
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
      if c_params[:contract_naic_id] && !ContractNaic.exists?(id: c_params[:contract_naic_id])
        c_params[:contract_naic_id] = ContractNaic.create(name: c_params[:contract_naic_id]).id
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
      if c_params[:contract_pop_id] && !ContractPop.exists?(id: c_params[:contract_pop_id])
        c_params[:contract_pop_id] = ContractPop.create(name: c_params[:contract_pop_id]).id
      end
      if c_params[:co_contract_poc_id] && !ContractProjectPoc.exists?(id: c_params[:co_contract_poc_id])
        c_params[:co_contract_poc_id] = ContractProjectPoc.create(name: c_params[:co_contract_poc_id]).id
      end
      if c_params[:gov_contract_poc_id] && !ContractProjectPoc.exists?(id: c_params[:gov_contract_poc_id])
        c_params[:gov_contract_poc_id] = ContractProjectPoc.create(name: c_params[:gov_contract_poc_id]).id
      end
      if c_params[:pm_contract_poc_id] && !ContractProjectPoc.exists?(id: c_params[:pm_contract_poc_id])
        c_params[:pm_contract_poc_id] = ContractProjectPoc.create(name: c_params[:pm_contract_poc_id]).id
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
      contract_project_data.attributes = c_params
      contract_project_data.user_id = user.id
      contract_project_data.save
    end
    # if params[:facility_group_name]
    #   contract.contract_facility_group.update(name: params[:facility_group_name])
    # end
    contract_project_data
  end

end
