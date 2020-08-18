class NotesController < AuthenticatedController
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
    if @note.update(note_params)
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
    params[:note][:destroy_file_ids].split(',').map(&:to_i)
  end

  def destroy_files_first
    @note.note_files.where(id: destroy_file_ids).map(&:purge)
  end
end
