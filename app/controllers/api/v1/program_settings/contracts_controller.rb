class Api::V1::ProgramSettings::ContractsController < AuthenticatedController 
  before_action :check_program_admin

  def index

    # all_contracts = Contract.includes(:facility_group, :contract_facility_group).where(project_id: params[:project_id] )

    # c = []
    # all_contracts.in_batches do |contracts|
    #   c << contracts.map(&:to_json)
    # end if all_contracts.any?
    # render json: {contracts: c, total_count: c.size}

    contract_project_data_ids = ProjectContract.where(project_id: params[:project_id]).pluck(:contract_project_datum_id).compact.uniq
    contract_project_datas = ContractProjectDatum.where(id: contract_project_data_ids )
    c = []
    contract_project_datas.in_batches do |contract_project_data|
      c << contract_project_data.map(&:to_json)
    end if contract_project_datas.any?
    render json: {contracts: c, total_count: c.size}

  end

end