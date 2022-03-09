class Contract < ApplicationRecord
  belongs_to :contract_type, optional: true
  belongs_to :contract_status, optional: true
  belongs_to :contract_customer, optional: true
  belongs_to :contract_vehicle, optional: true
  belongs_to :contract_vehicle_number, optional: true
  belongs_to :contract_number, optional: true
  belongs_to :subcontract_number, optional: true
  belongs_to :contract_prime, optional: true
  belongs_to :contract_current_pop, optional: true
  belongs_to :contract_classification, optional: true
  belongs_to :contract_client_type, optional: true
  belongs_to :contract_category, optional: true

  belongs_to :facility_group, optional: true
  belongs_to :project, optional: true
  belongs_to :contract_project, class_name: "Project", foreign_key: :project_id
  belongs_to :contract_facility_group, class_name: "FacilityGroup", foreign_key: :facility_group_id

  has_many :tasks
  has_many :issues
  has_many :risks
  has_many :lessons
  has_many :notes, as: :noteable, dependent: :destroy

  before_save :assign_default_contract_type
  before_save :assign_default_facility_group

  validates_presence_of :nickname

  # validates_presence_of :contract_type_id, :contract_status_id, :contract_customer_id, :contract_vehicle_id, :contract_vehicle_number_id, :contract_number_id, :subcontract_number_id, :contract_prime_id, :contract_current_pop_id,:project_code, :nickname, :contract_classification_id, :current_pop_start_time, :current_pop_end_time, :days_remaining, :total_contract_value, :current_pop_value, :current_pop_funded, :total_contract_funded, :start_date, :end_date
  before_create :assign_default_facility_group 


  def assign_default_facility_group
    if self.facility_group.nil?
      self.facility_group_id = FacilityGroup.unassigned.id
    end
  end
  
  def to_json(options: {})

    if options[:include_associated_names]
      self.as_json(except: [:created_at, :updated_at, :contract_type_id, :contract_status_id, :contract_name_customer_id, :contract_vehicle_id, :contract_vehicle_number_id, :contract_number_id, :subcontract_number_id, :contract_prime_id, :contract_current_pop_id, :contract_classification_id, :contract_client_type_id, :contract_category_id]).merge(
        class_name: self.class.name,
        contract_type: contract_type.as_json(except: [:created_at, :updated_at]),
        contract_status: contract_status.as_json(except: [:created_at, :updated_at]),
        contract_customer: contract_customer.as_json(except: [:created_at, :updated_at]),
        contract_vehicle: contract_vehicle.as_json(except: [:created_at, :updated_at]),
        contract_vehicle_number: contract_vehicle_number.as_json(except: [:created_at, :updated_at]),
        contract_number: contract_number.as_json(except: [:created_at, :updated_at]),
        subcontract_number: subcontract_number.as_json(except: [:created_at, :updated_at]),
        contract_prime: contract_prime.as_json(except: [:created_at, :updated_at]),
        contract_current_pop: contract_current_pop.as_json(except: [:created_at, :updated_at]),
        contract_classification: contract_classification.as_json(except: [:created_at, :updated_at]),
        contract_client_type: contract_client_type.as_json(except: [:created_at, :updated_at]),
        contract_category: contract_category.as_json(except: [:created_at, :updated_at])        
      ).as_json
    else
      self.as_json(except: [:created_at, :updated_at]).merge(facility_group_name: contract_facility_group&.name)
    end
  end

  def self.params_to_permit
    [
      :id,
      :total_subcontracts,
      :notes,
      :contract_client_type_id,
      :contract_category_id,
      :contract_type_id,
      :project_code,
      :nickname,
      :name,
      :contract_status_id,
      :contract_customer_id,
      :contract_vehicle_id,
      :contract_vehicle_number_id,
      :contract_number_id, 
      :contract_classification_id, 
      :subcontract_number_id, 
      :contract_prime_id, 
      :start_date,
      :end_date,
      :contract_current_pop_id, 
      :current_pop_start_time,
      :current_pop_end_time,
      :days_remaining,
      :total_contract_value,
      :current_pop_value,
      :current_pop_funded,
      :total_contract_funded,
      :facility_group_id,
      :facility_group_name,
      :project_id
    ]
  end
  
  def assign_default_facility_group
    if !self.facility_group.present?
      self.facility_group_id = FacilityGroup.unassigned.id
    end
  end

  def assign_default_contract_type
    if !self.contract_type_id.present?
      self.contract_type_id = ContractType.prime.id
    end
  end

  def create_or_update_issue(params, user)
    contract_params = params.require(:contract).permit(Contract.params_to_permit)
    c_params = contract_params.dup
    if c_params[:id]
      contract = Contract.find(c_params[:id])
    else
      contract = self
    end
    contract.transaction do
      c_params.reject!{|k,v| v == 'undefined'}

      if c_params[:contract_type_id] && !ContractType.exists?(id: c_params[:contract_type_id])
        c_params[:contract_type_id] = ContractType.create(name: c_params[:contract_type_id]).id
      end
      if c_params[:contract_status_id] && !ContractStatus.exists?(id: c_params[:contract_status_id])
        c_params[:contract_status_id] = ContractStatus.create(name: c_params[:contract_status_id]).id
      end
      if c_params[:contract_customer_id] && !ContractCustomer.exists?(id: c_params[:contract_customer_id])
        c_params[:contract_customer_id] = ContractCustomer.create(name: c_params[:contract_customer_id]).id
      end
      if c_params[:contract_vehicle_id] && !ContractVehicle.exists?(id: c_params[:contract_vehicle_id])
        c_params[:contract_vehicle_id] = ContractVehicle.create(name: c_params[:contract_vehicle_id]).id
      end
      if c_params[:contract_vehicle_number_id] && !ContractVehicleNumber.exists?(id: c_params[:contract_vehicle_number_id])
        c_params[:contract_vehicle_number_id] = ContractVehicleNumber.create(name: c_params[:contract_vehicle_number_id]).id
      end
      if c_params[:contract_number_id] && !ContractNumber.exists?(id: c_params[:contract_number_id])
        c_params[:contract_number_id] = ContractNumber.create(name: c_params[:contract_number_id]).id
      end
      if c_params[:subcontract_number_id] && !SubcontractNumber.exists?(id: c_params[:subcontract_number_id])
        c_params[:subcontract_number_id] = SubcontractNumber.create(name: c_params[:subcontract_number_id]).id
      end
      if c_params[:contract_prime_id] && !ContractPrime.exists?(id: c_params[:contract_prime_id])
        c_params[:contract_prime_id] = ContractPrime.create(name: c_params[:contract_prime_id]).id
      end
      if c_params[:contract_current_pop_id] && !ContractCurrentPop.exists?(id: c_params[:contract_current_pop_id])
        c_params[:contract_current_pop_id] = ContractCurrentPop.create(name: c_params[:contract_current_pop_id]).id
      end
      if c_params[:contract_classification_id] && !ContractClassification.exists?(id: c_params[:contract_classification_id])
        c_params[:contract_classification_id] = ContractClassification.create(name: c_params[:contract_classification_id]).id
      end
      if c_params[:contract_client_type_id] && !ContractClientType.exists?(id: c_params[:contract_client_type_id])
        c_params[:contract_client_type_id] = ContractClientType.create(name: c_params[:contract_client_type_id]).id
      end
      if c_params[:contract_category_id] && !ContractCategory.exists?(id: c_params[:contract_category_id])
        c_params[:contract_category_id] = ContractCategory.create(name: c_params[:contract_category_id]).id
      end
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
