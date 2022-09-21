class ContractVehicle < ApplicationRecord

  belongs_to :contract_sub_category, optional: true
  belongs_to :contract_agency, optional: true
  belongs_to :contract_vehicle_type, optional: true
  belongs_to :contract_number, optional: true
  belongs_to :user

  has_many :contract_project_data
  has_many :project_contract_vehicles, dependent: :destroy
  has_many :projects, through: :project_contract_vehicles

  # validates_presence_of :name

  before_save :set_is_subprime

  def to_json(options={})
    h = self.as_json
    vehicle = self
    # if options[:authorized_project_ids]
    #   _projects = projects.select{|p| options[:authorized_project_ids].include?(p.id) }
    #   h.merge!({associated_projects: _projects.map{|p| {id: p.id, name: p.name} } })
    # end
    if options[:authorized_project_ids]
      _project_contract_vehicles = project_contract_vehicles
      associated_projects = []
      projects.each do |p|
        if options[:authorized_project_ids].include?(p.id)
          pc = _project_contract_vehicles.detect{|_pc| _pc.project_id == p.id }
          # if vehicle has contract_task permission then only show
          if options[:role_users][pc.id]
            associated_projects << {id: p.id, name: p.name, project_contract_vehicle_id: pc.id}
          end
        end
      end
      h.merge!({associated_projects: associated_projects })
    end
    h.merge!({contract_sub_category: contract_sub_category.as_json})
    h.merge!({contract_agency: contract_agency.as_json})
    h.merge!({contract_vehicle_type: contract_vehicle_type.as_json})
    h.merge!({contract_number: contract_number.as_json})
    h
  end

  def self.preload_array
    [:contract_sub_category, :contract_agency, :contract_vehicle_type, :contract_number ]
  end

  def self.params_to_permit
    [:name, :id, :full_name, :contract_agency_id, :contract_vehicle_type_id, :contract_number, :ceiling, :base_period_start, :base_period_end, :option_period_start, :option_period_end, :contract_sub_category_id, :user_id, :contract_number_id, :caf_fees, :subprime_name, :prime_name, :contract_name, :is_subprime]
  end

  def set_is_subprime
    if subprime_name.present?
      self.is_subprime = true
    end
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
