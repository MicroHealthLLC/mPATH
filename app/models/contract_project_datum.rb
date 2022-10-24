class ContractProjectDatum < ApplicationRecord
  belongs_to :contract_customer, optional: true
  belongs_to :contract_vehicle, optional: true
  belongs_to :contract_award_to, optional: true
  belongs_to :contract_naic, optional: true
  belongs_to :contract_award_type, optional: true
  belongs_to :contract_type, optional: true
  belongs_to :contract_current_pop, optional: true
  belongs_to :contract_pop, optional: true
  belongs_to :contract_number, optional: true
  belongs_to :user, optional: true
  has_many :project_contracts, dependent: :destroy
  has_many :projects, through: :project_contracts

  has_many :contract_project_poc_resources, dependent: :destroy, as: :resource
  has_many :contract_project_pocs, through: :contract_project_poc_resources

  validates :charge_code, :name, :contract_customer_id, :contract_naic_id, :contract_award_type_id, :contract_start_date, :contract_end_date, :total_contract_value, :contract_pop_id, :contract_current_pop_start_date, :contract_current_pop_end_date, presence: true
  
  validate :number_check

  def number_check
    if contract_number_id.blank? && number.blank?
      errors.add(:base, "Contract number or Awared/TO number is required")
      return false
    end
  end

  def to_json(options = {})
    h = self.as_json
    if options[:authorized_project_ids]
      _project_contracts = project_contracts
      associated_projects = []
      projects.each do |p|
        if options[:authorized_project_ids].include?(p.id)
          pc = _project_contracts.detect{|_pc| _pc.project_id == p.id }
          # if contract has contract_task permission then only show
          if options[:role_users][pc.id]
            associated_projects << {id: p.id, name: p.name, project_contract_id: pc.id}
          end
        end
      end
      h.merge!({associated_projects: associated_projects })
    end
    h.merge!({project_contract_id: options[:project_contract].id }) if options[:project_contract]
    h.merge!({facility_group: options[:project_contract].facility_group.as_json }) if options[:project_contract]
    h.merge!({facility_group_id: options[:project_contract].facility_group_id }) if options[:project_contract]
    h.merge!({contract_customer: contract_customer.as_json})
    h.merge!({contract_vehicle: contract_vehicle.to_json})
    h.merge!({contract_award_to: contract_award_to.as_json})
    h.merge!({contract_pop: contract_pop.as_json})
    h.merge!({contract_naic: contract_naic.as_json})
    h.merge!({contract_award_type: contract_award_type.as_json})
    h.merge!({contract_type: contract_type.as_json})
    h.merge!({contract_current_pop: contract_current_pop.as_json})
    h.merge!({contract_number: contract_number.as_json})
    
    _contract_project_poc_resources = contract_project_poc_resources
    _co_contract_poc_ids = _contract_project_poc_resources.map{|c| c.contract_project_poc_id if c.poc_type == ContractProjectPoc::CONTRACT_OFFICE_POC_TYPE}.compact
    _gov_contract_poc_ids = _contract_project_poc_resources.map{|c| c.contract_project_poc_id if c.poc_type == ContractProjectPoc::GOVERNMENT_POC_TYPE}.compact
    _pm_contract_poc_ids = _contract_project_poc_resources.map{|c| c.contract_project_poc_id if c.poc_type == ContractProjectPoc::PROGRAM_MANAGER_POC_TYPE}.compact

    h.merge!({co_contract_poc_ids: _co_contract_poc_ids})
    h.merge!({gov_contract_poc_ids: _gov_contract_poc_ids})
    h.merge!({pm_contract_poc_ids: _pm_contract_poc_ids})

    h
  end

  def self.preload_array
    [:contract_customer, :contract_award_to, :contract_pop, :contract_naic, :contract_award_type, :contract_type, :contract_current_pop, :contract_number ]
  end

  def self.params_to_permit
    [
      :id, :contract_vehicle_id, :contract_award_type_id, :name, :charge_code, :contract_customer_id, :contract_award_to_id, :contract_type_id, :prime_or_sub, :contract_start_date, :contract_end_date, :total_contract_value, :contract_current_pop_id, :contract_current_pop_start_date, :contract_current_pop_end_date, :total_founded_value, :billings_to_date, :comments, :contract_naic_id, :contract_pop_id, :number, :contract_number_id, :facility_group_id, :notes, :ignore_expired, pm_contract_poc_ids: [], gov_contract_poc_ids: [], co_contract_poc_ids: []
    ]
  end

  def expired?
    contract_end_date < DateTime.now
  end

  def create_or_update_contract_project_data(params, user)
    contract_params = params.require(:contract_project_data).permit(ContractProjectDatum.params_to_permit)
    c_params = contract_params.dup
    if params[:id]
      contract_project_data = ContractProjectDatum.find(params[:id])
    else
      contract_project_data = self
    end

    contract_project_data.transaction do
      c_params.reject!{|k,v| v == 'undefined'}
      
      if c_params[:contract_number_id] && !( a = (Integer(c_params[:contract_number_id]) rescue nil) ) && !ContractNumber.exists?(id: a)
        c_params[:contract_number_id] = ContractNumber.create(name: c_params[:contract_number_id], user_id: user.id).id
      end
      
      if c_params[:contract_customer_id] && !( a = (Integer(c_params[:contract_customer_id]) rescue nil) ) && !ContractCustomer.exists?(id: a)
        c_params[:contract_customer_id] = ContractCustomer.create(name: c_params[:contract_customer_id], user_id: user.id).id
      end

      if c_params[:contract_vehicle_id] && !( a = (Integer(c_params[:contract_vehicle_id]) rescue nil) ) && !ContractVehicle.exists?(id: a)
        c_params[:contract_vehicle_id] = ContractVehicle.create(name: c_params[:contract_vehicle_id], user_id: user.id).id
      end
      
      if c_params[:contract_award_to_id] && !( a = (Integer(c_params[:contract_award_to_id]) rescue nil) ) && !ContractAwardTo.exists?(id: a)
        c_params[:contract_award_to_id] = ContractAwardTo.create(name: c_params[:contract_award_to_id], user_id: user.id).id
      end
      
      if c_params[:contract_naic_id] && !( a = (Integer(c_params[:contract_naic_id]) rescue nil) ) && !ContractNaic.exists?(id: a)
        c_params[:contract_naic_id] = ContractNaic.create(name: c_params[:contract_naic_id], user_id: user.id).id
      end
      
      if c_params[:contract_award_type_id] && !( a = (Integer(c_params[:contract_award_type_id]) rescue nil) ) && !ContractAwardType.exists?(id: a)
        c_params[:contract_award_type_id] = ContractAwardType.create(name: c_params[:contract_award_type_id], user_id: user.id).id
      end
      
      if c_params[:contract_type_id] && !( a = (Integer(c_params[:contract_type_id]) rescue nil) ) && !ContractType.exists?(id: a)
        c_params[:contract_type_id] = ContractType.create(name: c_params[:contract_type_id], user_id: user.id).id
      end
      
      if c_params[:contract_current_pop_id] && !( a = (Integer(c_params[:contract_current_pop_id]) rescue nil) ) && !ContractCurrentPop.exists?(id: a)
        c_params[:contract_current_pop_id] = ContractCurrentPop.create(name: c_params[:contract_current_pop_id], user_id: user.id).id
      end
      
      if c_params[:contract_pop_id] && !( a = (Integer(c_params[:contract_pop_id]) rescue nil) ) && !ContractPop.exists?(id: a)
        c_params[:contract_pop_id] = ContractPop.create(name: c_params[:contract_pop_id], user_id: user.id).id
      end
      
      pm_contract_poc_id = c_params.delete(:pm_contract_poc_ids)
      gov_contract_poc_id = c_params.delete(:gov_contract_poc_ids)
      co_contract_poc_id = c_params.delete(:co_contract_poc_ids)

      contract_project_data.attributes = c_params
      contract_project_data.user_id = user.id
      contract_project_data.save!
      
      contract_project_data.add_contract_pocs(pm_contract_poc_id, ContractProjectPoc::PROGRAM_MANAGER_POC_TYPE )
      contract_project_data.add_contract_pocs(gov_contract_poc_id, ContractProjectPoc::GOVERNMENT_POC_TYPE)
      contract_project_data.add_contract_pocs(co_contract_poc_id, ContractProjectPoc::CONTRACT_OFFICE_POC_TYPE)

    end
    contract_project_data
  end

  def add_contract_pocs(_contract_poc_ids = [], poc_type)
    return if !_contract_poc_ids
    contract_poc_ids = _contract_poc_ids.map(&:to_i)
    old_contract_project_poc_ids = ContractProjectPocResource.where(resource: self,poc_type: poc_type).pluck(:contract_project_poc_id)

    new_contract_project_poc_ids = (old_contract_project_poc_ids + contract_poc_ids ) - old_contract_project_poc_ids
    remove_contract_project_poc_ids = (old_contract_project_poc_ids + contract_poc_ids ) - contract_poc_ids

    if new_contract_project_poc_ids.any?
      _contract_pocs = []
      new_contract_project_poc_ids.each do |poc_id|
        _contract_pocs << ContractProjectPocResource.new(resource: self, contract_project_poc_id: poc_id, poc_type: poc_type)
      end
      ContractProjectPocResource.import(_contract_pocs)
    end
    
    if remove_contract_project_poc_ids
      ContractProjectPocResource.where(resource: self, contract_project_poc_id: remove_contract_project_poc_ids, poc_type: poc_type).destroy_all
    end
  end

end
