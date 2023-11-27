class Api::V1::RolesController < AuthenticatedController
  def program_setting_role
    render json: {program_admin_user_role: Role.program_admin_user_role.to_json}
  end  
end
