class Api::V1::ContractsController < AuthenticatedController

  def index
    authorized_program_ids = current_user.authorized_programs.pluck(:id)

    if authorized_program_ids.include?(params[:project_id].to_i)
      project_contracts = ProjectContract.includes(:contract_project_datum).where(project_id: params[:project_id])
      c = []
      project_contracts.in_batches do |_project_contracts|
        c += _project_contracts.map{|pc| pc.contract_project_datum.to_json({project_contract: pc}) }
      end
      render json: {contracts: c, total_count: c.size}
    else
      render json: {error: "You are not authorized to see contract!"}, status: 406
    end
  end

  def show
    authorized_program_ids = current_user.authorized_programs.pluck(:id)
    if authorized_program_ids.include?(params[:project_id].to_i)
      project_contract = ProjectContract.find(params[:id])
      render json: {contract: project_contract.contract_project_datum.to_json({project_contract: project_contract})}
    else
      render json: {error: "You are not authorized to see contract!"}, status: 406
    end
  end

  # def create
  #   @contract = Contract.new.create_or_update_issue(params, current_user)
  #   if @contract.errors.any?
  #     render json: {errors: @contract.errors.full_messages}, status: 406
  #   else
  #     render json: {contract: @contract.reload.as_json}
  #   end
  # end

  # def update
  #   @contract = Contract.new.create_or_update_issue(params, current_user)
  #   if @contract.errors.any?
  #     render json: {errors: @contract.errors.full_messages}, status: 406
  #   else
  #     render json: {contract: @contract.reload.as_json}
  #   end
  # end

  # def destroy
  #   @contract = Contract.find_by(id: params[:id])
  #   @contract.destroy!
  #   render json: {}, status: 200
  # rescue
  #   render json: {}, status: :not_found
  # end
end
