class Risk < ApplicationRecord
  include Normalizer
  include Tasker

  belongs_to :user
  has_many :risk_users, dependent: :destroy
  belongs_to :risk_stage, optional: true
  has_many :users, through: :risk_users
  belongs_to :task_type, optional: true
  has_many_attached :risk_files, dependent: :destroy
  has_many :notes, as: :noteable, dependent: :destroy

  enum risk_approach: [:avoid, :mitigate, :transfer, :accept]
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true

  # validates_inclusion_of :probability, in: 1..5
  # validates_inclusion_of :impact_level, in: 1..5
  validates_presence_of :risk_description
  validates :start_date, :due_date, presence: true, if: ->  { ongoing == false && on_hold == false }

  before_validation :cast_constants_to_i
  before_destroy :nuke_it!
  before_update :validate_states
  before_update :update_progress_on_stage_change, if: :risk_stage_id_changed?
  before_save :init_kanban_order, if: Proc.new {|risk| risk.risk_stage_id_was.nil?}

  # after_save :update_owner_record
  # after_destroy :update_owner_record

  scope :exclude_closed_in, -> (dummy) { where("closed_date is NULL") }
  scope :exclude_inactive_in, -> (dummy) { inactive_facility.inactive_project }

  attr_accessor :file_links

  amoeba do
    include_association :risk_stage
    include_association :user

    include_association :task_type
    include_association :risk_users
    include_association :users

    include_association :facility_project
    include_association :checklists
    include_association :related_tasks
    include_association :related_issues
    include_association :related_risks
    include_association :sub_tasks
    include_association :sub_issues
    include_association :sub_risks

    append :text => " - Copy"
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:exclude_closed_in, :exclude_inactive_in]
  end
  
  def files_as_json
    risk_files.reject {|f| valid_url?(f.blob.filename.instance_variable_get("@filename")) }.map do |file|
      {
        id: file.id,
        name: file.blob.filename,
        uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true),
        link: false
      }
    end.as_json
  end

  def links_as_json
    risk_files.reject {|f| !valid_url?(f.blob.filename.instance_variable_get("@filename")) }.map do |file|
      if file.blob.content_type == "text/plain" && valid_url?(file.blob.filename.instance_variable_get("@filename"))
        {
          id: file.id,
          name: file.blob.filename.instance_variable_get("@filename"),
          uri: file.blob.filename.instance_variable_get("@filename"),
          link: true
        }
      end
    end.as_json
  end

  def priority_level_name
    n = 'Very Low'
    n = 'Very Low' if [1].include?(priority_level)
    n = "Low" if [2,3].include?(priority_level)
    n = "Moderate" if [4,5,6].include?(priority_level)
    n = "High" if [8,9,10,12].include?(priority_level)
    n = "Extreme" if [15,16,20,25].include?(priority_level)
    n
  end

  def impact_level_name_hash
    {
      1 => "1 - Negligible",
      2 => "2 - Minor",
      3 => "3 - Moderate",
      4 => "4 - Major",
      5 => "5 - Catastrophic"
    }
  end

  def impact_level_name
    impact_level_name_hash[impact_level] || impact_level_name_hash[1]
  end

  def probability_name_hash
    {
      1 => "1 - Rare",
      2 => "2 - Unlikely",
      3 => "3 - Possible",
      4 => "4 - Likely",
      5 => "5 - Almost Certain"
    }
  end

  def probability_name
    probability_name_hash[probability] || probability_name_hash[1]
  end

  def portfolio_json(facility_groups: [], files: false)
    if draft
      self.on_hold = false if self.on_hold
      self.ongoing = false if self.ongoing
    end

    self.ongoing = false if on_hold && ongoing
    closed = self.closed_date.present?

    # closed = false
   
    # if ongoing && due_date.present? && !draft && !on_hold
    #   closed_date = due_date
    # end

    # if closed_date.present? && ongoing && !draft && !on_hold
    #    closed = true 
    # end 


    is_overdue = false
    if !ongoing && !on_hold && !draft
      is_overdue = ( progress < 100 && due_date && (due_date < Date.today) )
    end

    in_progress = false
    planned = false

    in_progress = true if !draft && !on_hold && !planned && !is_overdue && !ongoing && start_date <= Date.today && progress < 100
    planned = true if !draft && !in_progress && !ongoing && !on_hold && start_date > Date.today
    if start_date && progress && start_date <= Date.today && progress >= 100
      completed = true unless draft
      self.on_hold = false if self.on_hold && completed
    end

    if ongoing 
      progress_status = "active"
      completed = false
    end

    attach_files = []
    if files == true
      rf = self.risk_files
  
      if rf.attached?
        attach_files = rf.map do |file|
          next if !file.blob.filename.instance_variable_get("@filename").present?
          begin
            if file.blob.content_type == "text/plain" && valid_url?(file.blob.filename.instance_variable_get("@filename"))
              {
                id: file.id,
                name: file.blob.filename.instance_variable_get("@filename"),
                uri: file.blob.filename.instance_variable_get("@filename"),
                link: true
              }
            else
              {
                id: file.id,
                name: file.blob.filename,
                uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true),
                link: false
              }
            end
          rescue Exception => e
            puts "There is an exception"
          end
        end.compact.uniq
      end
    end

     merge_h = { 
      attach_files: attach_files,
      project_name: facility.facility_name, 
      program_name: project.name, 
      project_id: facility.id, 
      program_id: project.id, 
      category: task_type.name,
      is_overdue: is_overdue,
      program_progress:  self.project.progress,
      project_group_name: self.facility_group.name,
      project_due_date: self.facility_project.due_date,
      project_status: self.facility_project.status.name,
      in_progress: in_progress,
      closed: closed,
      on_hold: self.on_hold,
      ongoing: self.ongoing,
      risk_approach: risk_approach.humanize,
      risk_stage: risk_stage.try(:name),
      risk_stage_id: self.risk_stage_id,
      priority_level: priority_level_name,
      completed: completed,
      planned: planned,
      last_update: self.notes.last&.portfolio_json,
      notes: notes.as_json,
      notes_updated_at: notes.sort_by(&:updated_at).map(&:updated_at).last(1),
      users: users.select(&:active?).map(&:full_name).join(", "),
      risk_users: users.map{|u| {id: u.id, name: u.full_name } } 
    }

    self.attributes.merge!(merge_h)
  end

  def self.params_to_permit
    [
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
      :on_hold,
      :draft,
      :project_contract_id,
      :project_contract_vehicle_id,
      :ongoing,
      :duration,
      :duration_name,
      :status_name,
      :explanation,
      :risk_approach_description,
      :task_type_id,
      :task_type,
      :risk_stage_id,
      :progress,
      :start_date,
      :due_date,
      :closed_date,
      :auto_calculate,
      :text,
      :watched,
      :important,
      :reportable,
      user_ids: [],
      file_links: [],
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
    ]
  end

  def lesson_json
    {
      id: id,
      text: text,
      project_id: facility.id,
      project_name: facility.facility_name
    }
  end
  def to_json(options = {})
    attach_files = []
    rf = self.risk_files

    if rf.attached?
      attach_files = rf.map do |file|
        next if !file.blob.filename.instance_variable_get("@filename").present?
        begin
          if file.blob.content_type == "text/plain" && valid_url?(file.blob.filename.instance_variable_get("@filename"))
            {
              id: file.id,
              name: file.blob.filename.instance_variable_get("@filename"),
              uri: file.blob.filename.instance_variable_get("@filename"),
              link: true
            }
          else
            {
              id: file.id,
              name: file.blob.filename,
              uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true),
              link: false
            }
          end
        rescue Exception => e
          puts "There is an exception"
        end
      end.compact.uniq
    end

    fp = self.facility_project

    t_users = options[:all_risk_users] || []
    all_users = options[:all_users] || []
    if options[:for].present? && [:project_build_response, :risk_index].include?(options[:for])
      resource_users = t_users
    else
      resource_users = self.risk_users #.where(user_id: self.users.active.uniq.map(&:id) )
    end

    resource_user_ids = resource_users.map(&:user_id).compact.uniq

    accountable_user_ids = resource_users.map{|ru| ru.user_id if ru.accountable? }.compact.uniq
    responsible_user_ids = resource_users.map{|ru| ru.user_id if ru.responsible? }.compact.uniq
    consulted_user_ids = resource_users.map{|ru| ru.user_id if ru.consulted? }.compact.uniq
    informed_user_ids = resource_users.map{|ru| ru.user_id if ru.informed? }.compact.uniq

    risk_approver_user_ids = resource_users.map{|ru| ru.user_id if ru.approver? }.compact.uniq

    resource_user_ids += risk_approver_user_ids

    p_users = []
    if all_users.any?
      p_users = all_users.select{|u| resource_user_ids.include?(u.id) }
    else
      p_users = User.where(id: resource_user_ids).active
    end

    users_hash = {}
    p_users.map{|u| users_hash[u.id] = {id: u.id, name: u.full_name} }

    # Last name values added for improved sorting in datatables
    users_last_name_hash = {}
    p_users.map{|u| users_last_name_hash[u.id] = u.last_name }


    # First name values added for improved sorting in datatables
    users_first_name_hash = {}
    p_users.map{|u| users_first_name_hash[u.id] = u.first_name }

    sub_tasks = self.sub_tasks
    sub_issues = self.sub_issues
    sub_risks = self.sub_risks
    progress_status = "active"
 
    progress_status = "completed" if progress >= 100

    is_overdue = false
    is_overdue = progress < 100 && due_date && (due_date < Date.today) if !ongoing && !on_hold && !draft

    closed = self.closed_date.present?

    # closed = false
   
    # if ongoing && due_date.present? && !draft && !on_hold
    #   closed_date = due_date
    # end

    # if closed_date.present? && ongoing && !draft && !on_hold
    #    closed = true 
    # end 

    in_progress = false
    completed = false
    planned = false

    in_progress = true if !draft && !on_hold && !planned && !is_overdue && !ongoing && start_date <= Date.today && progress < 100
    planned = true if !draft && !in_progress && !ongoing && !on_hold && start_date > Date.today
    if start_date && start_date <= Date.today && progress && progress >= 100
      completed = true unless draft
      self.on_hold = false if self.on_hold && completed
    end

    if ongoing 
      progress_status = "active"
      completed = false
    end

    sorted_notes = notes.sort_by(&:created_at).reverse
    
    project = self.project_contract_id ? self.contract_project : self.project
    facility_group = self.project_contract_id ? self.contract_facility_group : self.facility_group

    self.as_json.merge(
      priority_level_name: priority_level_name,
      # risk_approach: risk_approach.humanize,
      probability_name: probability_name,
      impact_level_name: impact_level_name,
      task_type: task_type.as_json,
      category: task_type.try(:name),
      risk_stage: risk_stage.try(:name),
      risk_stage_id: self.risk_stage_id,
      class_name: self.class.name,
      completed: completed,
      planned: planned,
      project_group: facility_group&.name,
      program_name: project&.name, 
      closed: closed,
      in_progress: in_progress,
      attach_files: attach_files,
      progress_status: progress_status,
      checklists: checklists.as_json,
      due_date_duplicate: due_date.as_json,
      facility_id: fp.try(:facility_id),
      facility_name: fp.try(:facility)&.facility_name,
      # Remove this
      user_ids: p_users.map(&:id).compact.uniq,
      risk_owners: p_users.map(&:full_name).compact.join(", "),
      users: p_users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email]),
      user_names: p_users.map(&:full_name).compact.join(", "),
      is_overdue: is_overdue,
      draft: draft,
      on_hold: on_hold,
      closed_date: closed_date,

     # Add RACI user name
      # Last name values added for improved sorting in datatables
      responsible_users: responsible_user_ids.map{|id| users_hash[id] }.compact,
      responsible_users_last_name: responsible_user_ids.map{|id| users_last_name_hash[id] }.compact,
      responsible_users_first_name: responsible_user_ids.map{|id| users_first_name_hash[id] }.compact,
      accountable_users: accountable_user_ids.map{|id| users_hash[id] }.compact,
      accountable_users_last_name: accountable_user_ids.map{|id| users_last_name_hash[id] }.compact,
      accountable_users_first_name: accountable_user_ids.map{|id| users_first_name_hash[id] }.compact,
      consulted_users: consulted_user_ids.map{|id| users_hash[id] }.compact,
      informed_users: informed_user_ids.map{|id| users_hash[id] }.compact,


      # Add RACI user ids
      responsible_user_ids: responsible_user_ids,
      accountable_user_ids: accountable_user_ids,
      consulted_user_ids: consulted_user_ids,
      informed_user_ids: informed_user_ids,

      # Risk Approver name
      risk_approver:   risk_approver_user_ids.map{|id| users_hash[id] },

      # Risk Approver user ids
      risk_approver_user_ids: risk_approver_user_ids,

      notes: sorted_notes.as_json,
      contract_nickname:  self.contract_project_data.try(:name),
      vehicle_nickname: self.contract_vehicle.try(:name),
      notes_updated_at: sorted_notes.map(&:created_at).uniq,
      last_update: sorted_notes.first.as_json,
      project_id: fp.try(:project_id),
      sub_tasks: sub_tasks.as_json(only: [:text, :id]),
      sub_issues: sub_issues.as_json(only: [:title, :id]),
      sub_risks: sub_risks.as_json(only: [:risk_description, :id]),
      sub_task_ids: sub_tasks.map(&:id),
      sub_issue_ids: sub_issues.map(&:id),
      sub_risk_ids: sub_risks.map(&:id)
    ).as_json
  end

  # Below this line added by JR on 2/12/2021.....Delete this comment if no errors after 30 days.
  def create_or_update_risk(params, user)
    risk_params = params.require(:risk).permit(Risk.params_to_permit)

    risk = self
    r_params = risk_params.dup
    user_ids = r_params.delete(:user_ids)
    sub_task_ids = r_params.delete(:sub_task_ids)
    sub_issue_ids = r_params.delete(:sub_issue_ids)
    sub_risk_ids = r_params.delete(:sub_risk_ids)
    checklists_attributes = r_params.delete(:checklists_attributes)
    notes_attributes = r_params.delete(:notes_attributes)
    risk.user_id = user.id

    risk.attributes = r_params

    if params[:project_contract_id]
      risk.project_contract_id = params[:project_contract_id]
    elsif params[:project_contract_vehicle_id]
      risk.project_contract_vehicle_id = params[:project_contract_vehicle_id]

    elsif !risk.facility_project_id.present?
      project = user.projects.active.find_by(id: params[:project_id])
      facility_project = project.facility_projects.find_by(facility_id: params[:facility_id])

      risk.facility_project_id = facility_project.id
    end

    all_checklists = risk.checklists

    risk.transaction do
      risk.save

      if user_ids && user_ids.present?
        risk_users_obj = []
        user_ids.each do |uid|
          next if !uid.present?
          risk_users_obj << RiskUser.new(risk_id: risk.id, user_id: uid)
        end
        RiskUser.import(risk_users_obj) if risk_users_obj.any?
      end

      if sub_risk_ids && sub_risk_ids.any?
        related_risk_objs = []
        related_risk_objs2 = []
        sub_risk_ids.each do |sid|
          related_risk_objs << RelatedRisk.new(relatable_id: risk.id, relatable_type: "Risk", risk_id: sid)
          related_risk_objs2 << RelatedRisk.new(relatable_id: sid, relatable_type: "Risk", risk_id: risk.id)
        end
        RelatedRisk.import(related_risk_objs) if related_risk_objs.any?
        RelatedRisk.import(related_risk_objs2) if related_risk_objs2.any?
      end

      if sub_issue_ids && sub_issue_ids.any?
        related_issue_objs = []
        related_issue_objs2 = []
        sub_issue_ids.each do |sid|
          related_issue_objs << RelatedIssue.new(relatable_id: risk.id, relatable_type: "Risk", issue_id: sid)
          related_issue_objs2 << RelatedRisk.new(relatable_id: sid, relatable_type: "Issue", risk_id: risk.id)
        end
        RelatedIssue.import(related_issue_objs) if related_issue_objs.any?
        RelatedRisk.import(related_issue_objs2) if related_issue_objs2.any?
      end

      if sub_task_ids && sub_task_ids.any?
        related_task_objs = []
        related_task_objs2 = []
        sub_task_ids.each do |sid|
          related_task_objs << RelatedTask.new(relatable_id: risk.id, relatable_type: "Risk", task_id: sid)
          related_task_objs2 << RelatedRisk.new(relatable_id: sid, relatable_type: "Task", risk_id: risk.id)
        end
        RelatedTask.import(related_task_objs) if related_task_objs.any?
        RelatedRisk.import(related_task_objs2) if related_task_objs2.any?
      end

      if checklists_attributes.present?
        checklist_objs = []
        checklists_attributes.each do |key, value|
          if value["id"].present?
            c = all_checklists.detect{|cc| cc.id == value["id"].to_i}
            if value["_destroy"].present? && value["_destroy"] == "true"
              c.destroy
            else
              # TODO: Use upsert_all in Rails 6
              c.attributes = value
              c.save
            end
          else
            value.delete("_destroy")
            # checklist_objs << Checklist.new(value.merge({listable_id: risk.id, listable_type: "Risk"}) )
            c = Checklist.new(value.merge({listable_id: risk.id, listable_type: "Risk"}) )
            c.progress_lists.each do |p|
              p.user_id = user.id
            end
            c.save
          end
        end
        Checklist.import(checklist_objs) if checklist_objs.any?
      end

      if notes_attributes.present?
        notes_objs = []
        notes_attributes.each do |key, value|
          value.delete("_destroy")
          notes_objs << Note.new(value.merge({noteable_id: risk.id, noteable_type: "Risk"}) )
        end
        Note.import(notes_objs) if notes_objs.any?
      end

      risk.assign_users(params)

    end
    risk.add_link_attachment(params)
    risk.update_closed

    risk.reload
  end

  def add_link_attachment(params = {})
    link_files = params[:file_links]
    if link_files && link_files.any?
      link_files.each do |f|
        next if !f.present? || f.nil? || !valid_url?(f)
        filename = f
        if f.length > URL_FILENAME_LENGTH
          filename = f.truncate(URL_FILENAME_LENGTH, :separator => '') + "..."
        end 
        self.risk_files.attach(io: StringIO.new(f), filename: filename, content_type: "text/plain")
      end
    end
  end

  # Above this line Added by JR to fix Watched and add Approved values

  def assign_users(params)
    accountable_resource_users = []
    responsible_resource_users = []
    consulted_resource_users = []
    informed_resource_users = []
    approver_resource_users = []

    resource = self
    resource_users = resource.risk_users
    accountable_user_ids = resource_users.map{|ru| ru.user_id if ru.accountable? }.compact
    responsible_user_ids = resource_users.map{|ru| ru.user_id if ru.responsible? }.compact
    consulted_user_ids = resource_users.map{|ru| ru.user_id if ru.consulted? }.compact
    informed_user_ids = resource_users.map{|ru| ru.user_id if ru.informed? }.compact
    risk_approver_user_ids = resource_users.map{|ru| ru.user_id if ru.approver? }.compact

    users_to_delete = []

    if params[:accountable_user_ids].present?
      params[:accountable_user_ids].each do |uid|
        next if uid == "undefined"
        if !accountable_user_ids.include?(uid.to_i)
          accountable_resource_users << RiskUser.new(user_id: uid, risk_id: resource.id, user_type: 'accountable')
        end
      end
      users_to_delete += accountable_user_ids - params[:accountable_user_ids].map(&:to_i)
    end

    if params[:responsible_user_ids].present?
      params[:responsible_user_ids].each do |uid|
        next if uid == "undefined"
        if !responsible_user_ids.include?(uid.to_i)
          responsible_resource_users << RiskUser.new(user_id: uid, risk_id: resource.id, user_type: 'responsible')
        end
      end
      users_to_delete += responsible_user_ids - params[:responsible_user_ids].map(&:to_i)
    end

    if params[:consulted_user_ids].present?
      params[:consulted_user_ids].each do |uid|
        next if uid == "undefined"
        if !consulted_user_ids.include?(uid.to_i)
          consulted_resource_users << RiskUser.new(user_id: uid, risk_id: resource.id, user_type: 'consulted')
        end
      end
      users_to_delete += consulted_user_ids - params[:consulted_user_ids].map(&:to_i)
    end

    if params[:informed_user_ids].present?
      params[:informed_user_ids].each do |uid|
        next if uid == "undefined"
        if !informed_user_ids.include?(uid.to_i)
          informed_resource_users << RiskUser.new(user_id: uid, risk_id: resource.id, user_type: 'informed')
        end
      end
      users_to_delete += informed_user_ids - params[:informed_user_ids].map(&:to_i)
    end

    # Risk Approver (aka: Risk Approach Approver is not part of RACI users but still a user within Risks module)
    if params[:risk_approver_user_ids].present?
      params[:risk_approver_user_ids].each do |uid|
        next if uid == "undefined"
        if !risk_approver_user_ids.include?(uid.to_i)
          approver_resource_users << RiskUser.new(user_id: uid, risk_id: resource.id, user_type: 'approver')
        end
      end
      users_to_delete += risk_approver_user_ids - params[:risk_approver_user_ids].map(&:to_i)
    end

    records_to_import = accountable_resource_users + responsible_resource_users + consulted_resource_users + informed_resource_users + approver_resource_users

    if users_to_delete.any?
      resource_users.where(user_id: users_to_delete).destroy_all
    end

    if records_to_import.any?
      RiskUser.import(records_to_import)
    end
  end

  def status_name_hash
    {
      1 => "Monitoring",
      2 => "Resolved",
      3 => "Closed"
    }
  end

  def status_name
    status_name_hash[status] || status_name_hash[1]
  end

  def duration_name_hash
    {
      1 => "Temporary",
      2 => "Perpetual"
    }
  end

  def duration_name
    duration_name_hash[duration] || duration_name_hash[1]
  end

  def manipulate_links(params)
    return unless params[:risk][:file_links].present?
    link_params = JSON.parse(params[:risk][:file_links])
    link_params.each do |link|
      next if !link.present? || link.nil? || !valid_url?(link["uri"])
      if link['_destroy']
        risk_files.find_by_id(link['id'])&.purge
      elsif link['_new']
        self.risk_files.attach(io: StringIO.new(link['uri']), filename: link['uri'], content_type: "text/plain")
      end
    end
  end

  def manipulate_files(params)
    return unless params[:risk][:risk_files].present?
    file_blobs = JSON.parse(params[:risk][:risk_files])
    file_blobs.each do |file|
      if file['_destroy']
        risk_files.find_by_id(file['id'])&.purge
      elsif file['_new']
        risk_files.new(blob_id: file['id'])
      end
    end
  end

  def nuke_it!
    RelatedRisk.where(risk_id: self.id).or(RelatedRisk.where(relatable: self)).destroy_all
  end

  def init_kanban_order
    self.kanban_order = facility_project.risks.where(risk_stage_id: risk_stage_id).maximum(:kanban_order) + 1 rescue 0 if self.risk_stage_id.present?
  end

  def update_progress_on_stage_change
    if risk_stage.present?
      self.progress = risk_stage.percentage
      self.auto_calculate = false
    end
  end

  private
  def cast_constants_to_i
    self.probability = self.probability.to_i
    self.impact_level = self.impact_level.to_i
    self.duration = self.duration.to_i
    self.priority_level = self.probability * self.impact_level
  end

  def validate_states
    if self.draft?
      self.ongoing = self.on_hold = false
    elsif self.on_hold?
      self.ongoing = false
    end
  end
end