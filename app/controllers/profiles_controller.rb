class ProfilesController < AuthenticatedController
  def index; end

  def current_profile
    render json: current_user.as_json, status: 200
  end

  def update
    if current_user.update(profile_params)
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
      :role,
      :lat,
      :lng,
      :password,
      :password_confirmation,
      :country_code
    )
  end
end
