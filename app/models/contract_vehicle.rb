class ContractVehicle < ApplicationRecord

  belongs_to :contract_sub_category, optional: true
  belongs_to :contract_agency, optional: true
  belongs_to :contract_vehicle_type, optional: true
  belongs_to :contract_number, optional: true
  belongs_to :user

  has_many :contract_project_data
 
  validates_presence_of :name

  def to_json
    h = self.as_json
    vehicle = self
    h.merge!({contract_sub_category: contract_sub_category.as_json})
    h.merge!({contract_agency: contract_agency.as_json})
    h.merge!({contract_vehicle_type: contract_vehicle_type.as_json})
    h.merge!({contract_number: contract_number.as_json})
    h
  end

  def self.params_to_permit
    [:name, :id, :full_name, :contract_agency_id, :contract_vehicle_type_id, :contract_number, :ceiling, :base_period_start, :base_period_end, :option_period_start, :option_period_end, :contract_sub_category_id, :user_id, :contract_number_id, :caf_fees]
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
      # NOTE: Requirement is, user will always enter contract_number in contract_vehicle form in front end. So we will always recieve
      # string value in parameter. This contract_number should also be available in contract_project_data i.e. contract_detail tab
      # So to achieve this we will save this as contract_number_id and allow contract_project_data to use contract_number as select
      # options
      if c_params[:contract_number_id]
        cn = ContractNumber.find_or_create_by(name: c_params[:contract_number_id]) do |c|
          c.user_id = user.id
        end
        c_params[:contract_number_id] = cn.id
      end

      if c_params[:contract_sub_category_id] && !( a = (Integer(c_params[:contract_sub_category_id]) rescue nil) ) && !ContractSubCategory.exists?(id: c_params[:contract_sub_category_id])
        c_params[:contract_sub_category_id] = ContractSubCategory.create(name: c_params[:contract_sub_category_id], user_id: user.id).id
      end
      if c_params[:contract_agency_id] && !( a = (Integer(c_params[:contract_agency_id]) rescue nil) ) && !ContractAgency.exists?(id: c_params[:contract_agency_id])
        c_params[:contract_agency_id] = ContractAgency.create(name: c_params[:contract_agency_id], user_id: user.id).id
      end
      if c_params[:contract_vehicle_type_id] && !( a = (Integer(c_params[:contract_vehicle_type_id]) rescue nil) ) && !ContractVehicleType.exists?(id: c_params[:contract_vehicle_type_id])
        c_params[:contract_vehicle_type_id] = ContractVehicleType.create(name: c_params[:contract_vehicle_type_id], user_id: user.id).id
      end
     
      contract_vehicle.attributes = c_params
      contract_vehicle.user_id = user.id
      contract_vehicle.save
    end
    contract_vehicle
  end

end
