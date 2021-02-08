class Facilities::NotesController < NotesController
  before_action :set_noteable
  before_action :set_note, only: [:update, :destroy]

  private
  def set_noteable
    if params[:facility_project_id].present?
      @noteable = FacilityProject.find(params[:facility_project_id])
    else
      @project = current_user.projects.active.find(params[:project_id])
      @noteable = @project.facility_projects.find_by(facility_id: params[:facility_id])
    end
  end

  def set_note
    @note = Note.find(params[:id])    
  end
end
