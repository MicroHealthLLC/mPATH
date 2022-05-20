class Api::V1::ContractsController < AuthenticatedController

  def add_contract
    project_contract = ProjectContract.new(project_id: params[:project_id], contract_id: params[:id])
    if project_contract.save
      render json: {message: "Contract added successfully"}
    else
      render json: {error: project_contract.errors.full_messages}, status: 406
    end
  end

  def index
    authorized_program_ids = current_user.authorized_programs.pluck(:id)

    all_contracts = []
    if params[:project_id] && authorized_program_ids.include?(params[:project_id].to_i)
      cph = current_user.contract_privileges_hash_by_role(program_ids: [params[:project_id]] )
      contract_ids = cph.keys
      all_contracts = Contract.includes(:facility_group, :contract_facility_group).where(id: contract_ids, project_id: params[:project_id] )
    elsif !params[:project_id]
      cph = current_user.contract_privileges_hash_by_role
      contract_ids = cph.keys
      all_contracts = Contract.includes(:facility_group, :contract_facility_group).where(id: contract_ids)
    end
    c = []
    all_contracts.in_batches do |contracts|
      c << contracts.map(&:to_json)
    end if all_contracts.any?
    render json: {contracts: c, total_count: all_contracts.count}
  end

  def show
    @contract = Contract.find(params[:id])
    render json: @contract.to_json(options: {include_associated_names: false})
  end

  def create
    @contract = Contract.new.create_or_update_issue(params, current_user)
    if @contract.errors.any?
      render json: {errors: @contract.errors.full_messages}, status: 406
    else
      render json: {contract: @contract.reload.as_json}
    end
  end

  def update
    @contract = Contract.new.create_or_update_issue(params, current_user)
    if @contract.errors.any?
      render json: {errors: @contract.errors.full_messages}, status: 406
    else
      render json: {contract: @contract.reload.as_json}
    end
  end

  def destroy
    @contract = Contract.find_by(id: params[:id])
    @contract.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: :not_found
  end
end
