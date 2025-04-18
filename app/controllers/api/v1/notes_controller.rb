class Api::V1::NotesController < AuthenticatedController 
# class Api::V1::NotesController < Api::ApplicationController
  before_action :set_noteable
  before_action :set_note, only: [:update, :destroy]

  before_action :check_permission

  def check_permission
    action = nil
    if ["index", "show" ].include?(params[:action]) 
      action = "read"
    elsif ["create", "update"].include?(params[:action]) 
      action = "write"
    elsif ["destroy"].include?(params[:action]) 
      action = "delete"
    end

    if params[:project_contract_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'notes', project_contract: params[:project_contract_id])
    elsif params[:project_contract_vehicle_id]
      raise(CanCan::AccessDenied) if !current_user.has_contract_permission?(action: action,resource: 'notes', project_contract_vehicle: params[:project_contract_vehicle_id])
    else
      raise(CanCan::AccessDenied) if !current_user.has_permission?(action: action,resource: 'notes', program: params[:project_id], project: params[:facility_id])
    end

  end

  def index

    if @owner
      notes = Note.where(noteable_id: @owner.id, noteable_type: @owner.class.name)
      response_hash = {notes: notes.map(&:to_json)}
      status_code = 200
    else
      response_hash = {errors: "Program or Project not found"}
      status_code = 404
    end
    render json: response_hash, status: status_code

  end

  def show
    @note = Note.find(params[:id])    
    render json: {notes: @note.to_json}, status: 200
  end

  def create
    @note = @owner.notes.new(note_params)
    @note.user = current_user
    if @note.save
      render json: {note: @note.to_json, msg: "Note created successfully." }, status: 200
    else
      render json: {errors: @note.errors.full_messages, msg: @note.errors.full_messages}, status: 406
    end
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    if @note.update(note_params.merge({noteable: @owner}))
      render json: {note: @note.to_json, msg: "Note updated successfully." }, status: 200
    else
      render json: {errors: @note.errors.full_messages, msg: "Error updating Note."}, status: 406
    end
  end

  def destroy
    if @note.destroy
      render json: {note: @note.to_json, msg: "Note destroyed successfully."}, status: 200
    else
      render json: {errors: @note.errors.full_messages, msg: "Error destroying notes"}, status: 406
    end
  end

  private
  def set_noteable

    @owner = nil
    if params[:project_contract_id]
      @owner = current_user.authorized_contracts.find_by(id: params[:project_contract_id] )
    elsif params[:project_contract_vehicle_id]
      @owner = ProjectContractVehicle.find_by(id: params[:project_contract_vehicle_id] )
    else
      @project = current_user.authorized_programs.find_by(id: params[:project_id])
      @owner = @project.facility_projects.find_by(facility_id: params[:facility_id])
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
