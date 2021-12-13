class Api::V1::NotesController < AuthenticatedController 
# class Api::V1::NotesController < Api::ApplicationController
  before_action :set_noteable
  before_action :set_note, only: [:update, :destroy]

  before_action :check_permission

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update", "create_duplicate", "create_bulk_duplicate", "batch_update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy"].include?(params[:action]) 
      action = "delete"
    end

    if params[:contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'notes', contract: params[:contract_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'notes', program: params[:project_id], project: params[:facility_id])
    end

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
  def set_noteable
    if params[:contract_id]
      @noteable = current_user.authorized_contracts.find_by(id: params[:contract_id] )
    elsif params[:project_id].present? && params[:facility_id].present?
      @project = current_user.authorized_programs.find(params[:project_id])
      @noteable = @project.facility_projects.find_by(facility_id: params[:facility_id])
    elsif params[:facility_project_id].present?
      @noteable = FacilityProject.find(params[:facility_project_id])      
    end
  end

  def set_note
    @note = Note.find(params[:id])    
  end
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
