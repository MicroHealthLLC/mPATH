class Api::V1::ProgramSettingsController < AuthenticatedController 
  
  def contracts
    authorized_program_ids = current_user.authorized_programs.pluck(:id)

    all_contracts = []
    if params[:project_id] && authorized_program_ids.include?(params[:project_id].to_i)
      cph = current_user.contract_privileges_hash_by_role(program_ids: [params[:project_id]] )
      contract_ids = cph.keys

      if current_user.is_program_admin?(params[:project_id])
        contract_ids = (contract_ids + Contract.where(project_id: params[:project_id]).pluck(:id) ).uniq
      end
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

end