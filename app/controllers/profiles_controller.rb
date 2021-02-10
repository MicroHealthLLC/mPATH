class ProfilesController < AuthenticatedController
  def index; end

  def current_profile
    @active_projects = current_user.projects.includes(:facility_groups).active
    facility_groups = @active_projects.map(&:facility_groups).flatten.uniq

    preferences = current_user.settings(:preferences).value
    h = {
      current_user: current_user.as_json,
      preferences: preferences,
      project_groups: facility_groups
    }
    render json: h, status: 200
  end

  def update
    if current_user.update(profile_params)
      current_user.settings(:preferences).update(preferences_params)
      render json: current_user.as_json, status: 200
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private
  def profile_params
    params.require(:profile).permit(
      :first_name,
      :last_name,
      :title,
      :phone_number,
      :address,
      :lat,
      :lng,
      :password,
      :password_confirmation,
      :country_code
    )
  end
  def preferences_params
    params.require(:preferences).permit(
      :navigation_menu,
      :sub_navigation_menu,
      :project_id,
      :project_group_id
    )
  end
end
