class Api::V1::PrivilegesController < AuthenticatedController
  def get_privileges
    pph = current_user.project_privileges_hash
    fph = current_user.facility_privileges_hash
    cph = current_user.contract_privileges_hash || {}
    render json: {program_privilges: pph, project_privileges: fph, contract_privileges: cph}
  end
end