class ContractVehicle < ApplicationRecord
  has_many :contracts
  belongs_to :contract_number, optional: true
  belongs_to :contract_sub_category, optional: true
  belongs_to :contract_agency, optional: true
  belongs_to :contract_vehicle_type, optional: true
  belongs_to :user
  validates_presence_of :name

  def to_json
    h = self.as_json
    h.merge!({contract_sub_category: contract_sub_category.as_json}) if contract_sub_category_id
    h.merge!({contract_agency: contract_agency.as_json}) if contract_agency_id
    h.merge!({contract_vehicle_type: contract_vehicle_type.as_json}) if contract_vehicle_type_id
    h
  end

  def self.params_to_permit
    [:name, :id, :full_name, :contract_agency_id, :contract_vehicle_type_id, :contract_number, :ceiling, :base_period_start, :base_period_end, :option_period_start, :option_period_end, :contract_sub_category_id, :user_id, :contract_number_id]
  end

  def create_or_update_contract_vehicle(params, user)
    contract_params = params.require(:contract_vehicle).permit(ContractVehicle.params_to_permit)
    c_params = contract_params.dup
    if c_params[:id]
      contract_vehicle = ContractVehicle.find(c_params[:id])
    else
      contract_vehicle = self
    end
    contract_vehicle.transaction do
      c_params.reject!{|k,v| v == 'undefined'}

      if c_params[:contract_sub_category_id] && !ContractSubCategory.exists?(id: c_params[:contract_sub_category_id])
        c_params[:contract_sub_category_id] = ContractSubCategory.create(name: c_params[:contract_sub_category_id], user_id: user.id).id
      end
      if c_params[:contract_agency_id] && !ContractAgency.exists?(id: c_params[:contract_agency_id])
        c_params[:contract_agency_id] = ContractAgency.create(name: c_params[:contract_agency_id], user_id: user.id).id
      end
      if c_params[:contract_vehicle_type_id] && !ContractVehicleType.exists?(id: c_params[:contract_vehicle_type_id])
        c_params[:contract_vehicle_type_id] = ContractVehicleType.create(name: c_params[:contract_vehicle_type_id], user_id: user.id).id
      end
 
      contract_vehicle.attributes = c_params
      contract_vehicle.user_id = user.id
      contract_vehicle.save
    end
    contract_vehicle
  end

end
