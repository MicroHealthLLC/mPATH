class Api::V1::ContractsController < AuthenticatedController

  def index
    authorized_program_ids = current_user.authorized_programs.pluck(:id)
    all_contracts = []
    if params[:project_id] && authorized_program_ids.include?(params[:project_id].to_i)
      all_contracts = Contract.includes(:facility_group).where(project_id: params[:project_id] )
    elsif !params[:project_id]
      all_contracts = Contract.includes(:facility_group).where(project_id: authorized_program_ids )
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
    @contract = Contract.find(params[:id])
    contract_privileges = ContractPrivilege.where("project_id = ? and user_id = ? and contract_ids like ?", @contract.project_id, current_user.id, "%#{@contract.id}%" ).reject{|cp| !cp.contract_ids.include?(@contract.id.to_s)}.first
    if contract_privileges && contract_privileges.admin.include?("D")
      if @contract.destroy
        render json: {}, status: 200
      end
    else
      raise CanCan::AccessDenied
    end

  end

end
