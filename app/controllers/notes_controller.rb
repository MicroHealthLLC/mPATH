class NotesController < AuthenticatedController

  before_action :check_permission

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update", "create_duplicate", "create_bulk_duplicate", "batch_update"].include?(params[:action]) 
      action == "write"
    elsif ["destroy"].include?(params[:action]) 
      action == "delete"
    end

    raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'notes', program: params[:project_id], project: params[:facility_id])

  end

  def create
    @note = @noteable.notes.new(note_params)
    @note.user = current_user
    if @note.save
      render json: @note.to_json, status: 200
    else
      render json: {}, status: 500
    end
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    if @note.update(note_params.merge({noteable: @noteable}))
      render json: @note.to_json, status: 200
    else
      render json: {}, status: 500
    end
  end

  def destroy
    @note.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: 500
  end

  private
  def note_params
    params.require(:note).permit(
      :id,
      :body,
      note_files: []
    )
  end

  def destroy_file_ids
    params[:note][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @note.note_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
