class RisksController < AuthenticatedController
  before_action :set_resources
  before_action :set_risk, only: [:show, :update, :destroy]

  def index

    all_users = []
    all_user_ids = []

    all_risks = Risk.unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility} ]).where(facility_project_id: @facility_project.id)
    all_risk_users = RiskUser.where(risk_id: all_risks.map(&:id) ).group_by(&:risk_id)
    all_user_ids += all_risk_users.values.flatten.map(&:user_id)
    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    risks = all_risks.compact.uniq

    h = []
    risks.each do |r|
      h << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :risk_index} )
    end

    render json: h

    # render json: {risks: @facility_project.risks.map(&:to_json)}
  end

  def create
    # @risk = Risk.create(risk_params.merge(user_id: current_user.id))
    # @risk.assign_users(params)
    
    @risk = Risk.new.create_or_update_risk(params, current_user)
    render json: {risk: @risk.reload.to_json}
  end

  def update
    destroy_files_first if destroy_file_ids.present?
    r_params = risk_params.dup
    if r_params[:checklists_attributes].present?
      r_params[:checklists_attributes].each do |key, hash|
        if hash["progress_lists_attributes"].present?
          hash["progress_lists_attributes"].each do |key2, hash2|
            hash2[:user_id] = current_user.id if hash2[:user_id].nil?
          end
        end
      end
    end
    @risk.update(r_params)
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
        :due_date,
        progress_lists_attributes: [
          :id,
          :_destroy,
          :body,
          :checklist_id,
          :user_id
        ]
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
