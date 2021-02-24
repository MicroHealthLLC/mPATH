class RisksController < AuthenticatedController
  before_action :set_resources
  before_action :set_risk, only: [:show, :update, :destroy]

  def index
    render json: {risks: @facility_project.risks.map(&:to_json)}
  end

  def create
    # @risk = Risk.create(risk_params.merge(user_id: current_user.id))
    # @risk.assign_users(params)
    
    @risk = Risk.new.create_or_update_risk(params, current_user)
    render json: {risk: @risk.reload.to_json}
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    @risk.update(risk_params)
    @risk.assign_users(params)

    render json: {risk: @risk.reload.to_json}
  end

  def show
    render json: {risk: @risk.to_json}
  end

  def destroy
    @risk.destroy!
    render json: {}, status: 200
  rescue
    render json: {}, status: 500
  end

  def batch_update
    Risk.update(params[:risks].keys, params[:risks].values)
    render json: @facility_project.as_json
  end

  private
  def set_resources
    @project = current_user.projects.active.find_by(id: params[:project_id])
    @facility_project = @project.facility_projects.find_by(facility_id: params[:facility_id])
  end
  

  def set_risk
    @risk = @facility_project.risks.find_by(id: params[:id])
  end

  def risk_params
    params.require(:risk).permit(
      :approved,
      :approved_at,
      :approval_time,
      :facility_project_id,
      :risk_description,
      :impact_description,
      :probability_description,
      :probability,
      :probability_name,
      :impact_level,
      :impact_level_name,
      :risk_approach,
      :risk_approach_description,
      :task_type_id,
      :task_type,
      # :risk_stage, <-- :risk_stage created error when saving watched status
      :risk_stage_id,
      :progress,
      :start_date,
      :due_date,
      :auto_calculate,
      :text,
      :watched,
      user_ids: [],
      risk_files: [],
      sub_task_ids: [],
      sub_issue_ids: [],
      sub_risk_ids: [],
      checklists_attributes: [
        :id,
        :_destroy,
        :text,
        :user_id,
        :checked,
        :position,
        :due_date
      ],
      notes_attributes: [
        :id,
        :_destroy,
        :user_id,
        :body
      ]
    )
  end

  def destroy_file_ids
    params[:risk][:destroy_file_ids]&.split(',')&.map(&:to_i)
  end

  def destroy_files_first
    @risk.risk_files.where(id: destroy_file_ids)&.map(&:purge)
  end
end
