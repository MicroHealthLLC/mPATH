class Api::V1::PrivilegesController < AuthenticatedController
  def get_privileges
    pph = current_user.project_privileges
    fph = current_user.facility_privileges
    cph = current_user.contract_privileges || {}
    render json: {program_privilges: pph, project_privileges: fph, contract_privileges: cph}
  end

  def update
    current_user.update(params_permit)
  end

  private
  def params_permit
    params.require(:user).permit!
  end
end