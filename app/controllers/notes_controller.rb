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

  def destroy_file
    file = @note.note_files.find_by(id: file_params[:id])
    file.purge if file.present?
    render json: {note: @note.to_json}
  end

  private
  def note_params
    params.require(:note).permit(
      :body,
      note_files: []
    )
  end

  def file_params
    params.require(:file).permit(:id, :uri)
  end
end
