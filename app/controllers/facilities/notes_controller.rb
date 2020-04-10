class Facilities::NotesController < NotesController
  before_action :set_noteable
  before_action :set_note, only: [:update, :destroy, :destroy_file]

  private
  def set_noteable
    @project = current_user.projects.active.find(params[:project_id])
    @noteable = @project.facility_projects.find_by(facility_id: params[:facility_id])
  end

  def set_note
    @note = @noteable.notes.find_by(id: params[:id])
  end
end
