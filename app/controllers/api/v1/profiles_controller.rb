# class Api::V1::ProfilesController < Api::ApplicationController
class Api::V1::ProfilesController < AuthenticatedController 

  def current_profile
    # @active_projects = current_user.authorized_programs.includes(:facility_groups)
    # facility_groups = @active_projects.map(&:facility_groups).flatten.uniq

    active_projects = current_user.authorized_programs
    active_project_ids = active_projects.map(&:id).compact.uniq
    all_facility_projects = FacilityProject.where(project_id: active_project_ids).compact.uniq
    all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
    all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq
    all_facilities = Facility.where(id: all_facility_ids).compact.uniq
    all_facility_group_ids = all_facilities.map(&:facility_group_id).compact.uniq
    all_facility_groups = FacilityGroup.where(id: all_facility_group_ids).compact.uniq

    project_hash = []

    active_projects.each do |project|
      facility_projects = all_facility_projects.select{|fp| fp.project_id == project.id }.compact.uniq
      facility_ids = facility_projects.map(&:facility_id).compact.uniq
      facilities = all_facilities.select{|f| facility_ids.include?(f.id) }.compact.uniq
      facility_group_ids = facilities.map(&:facility_group_id).compact.uniq
      facility_groups = all_facility_groups.select{|fg| facility_group_ids.include?(fg.id) }.compact.uniq
      
      next if !facilities.any?
      
      h = {
        id: project.id,
        name: project.name,
        project_group_ids: facility_group_ids,
        project_ids: facility_ids
      }
      project_hash << h
    end

    preferences = current_user.get_preferences.value.with_indifferent_access
    h = {
      current_user: current_user.as_json,
      preferences: preferences,
      programs: project_hash,
      project_groups: all_facility_groups.map{|f| {id: f.id, name: f.name } },
      projects: all_facilities.map{|f| {id: f.id, name: f.facility_name, facility_group_id: f.facility_group_id } }
    }
    render json: h, status: 200
  end

  def update
    if current_user.update(profile_params)
      current_user.settings(:preferences).update(preferences_params)
      render json: {current_user: current_user.as_json, preferences: current_user.get_preferences.value.with_indifferent_access, preference_url: current_user.preference_url }, status: 200
    else
      render json: {errors: current_user.errors.full_messages.join(", ")}, status: :unprocessable_entity
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
      :project_group_id,
      :program_id
    )
  end
end
