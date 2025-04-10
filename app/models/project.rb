#NOTE: Project is now program in front end

class Project < SortableRecord
  # default_scope {order(Project.order_humanize)}
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :facility_projects, dependent: :destroy
  has_many :facilities, through: :facility_projects
  has_many :facility_groups, through: :facility_projects
  has_many :project_facility_groups, dependent: :destroy
  has_many :project_groups, through: :project_facility_groups, class_name: "FacilityGroup"
  has_many :tasks, through: :facility_projects
  has_many :issues, through: :facility_projects
  has_many :risks, through: :facility_projects
  has_many :lessons, through: :facility_projects
  has_many :comments, as: :resource, dependent: :destroy, class_name: 'ActiveAdmin::Comment'
  accepts_nested_attributes_for :comments, reject_if: :reject_comment, allow_destroy: true

  belongs_to :project_type

  has_many :project_statuses, dependent: :destroy
  has_many :statuses, through: :project_statuses
  has_many :project_task_types, dependent: :destroy
  has_many :task_types, through: :project_task_types
  has_many :project_issue_types, dependent: :destroy
  has_many :issue_types, through: :project_issue_types
  has_many :project_issue_severities, dependent: :destroy
  has_many :issue_severities, through: :project_issue_severities
  has_many :project_task_stages, dependent: :destroy
  has_many :task_stages, through: :project_task_stages

  has_many :project_risk_stages, dependent: :destroy
  has_many :risk_stages, through: :project_risk_stages

  has_many :project_issue_stages, dependent: :destroy
  has_many :issue_stages, through: :project_issue_stages

  has_many :favorite_filters, dependent: :destroy
  has_many :query_filters, dependent: :destroy

  has_many :project_lesson_stages, dependent: :destroy
  has_many :lesson_stages, through: :project_lesson_stages
  
  has_many :contracts, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :role_users, dependent: :destroy

  has_many :project_contracts, dependent: :destroy
  has_many :contract_project_data, through: :project_contracts

  has_many :project_contract_vehicles, dependent: :destroy
  has_many :contract_vehicles, through: :project_contract_vehicles
  has_many :project_contract_vehicle_groups, through: :project_contract_vehicles, class_name: "FacilityGroup"

  enum status: %i[inactive active].freeze

  validates_uniqueness_of :name, case_sensitive: false
  validates :name, presence: true
  validate :check_min_program_admins

  before_create :set_uuid
  # after_save :grant_access_to_admins
  after_save :add_not_started_status

  scope :program_admins_contains, -> (email) { where(id: RoleUser.joins(:user).where("users.email LIKE ?", "%#{email}%").map(&:project_id)) }
  scope :program_admins_equals, -> (email) { where(id: RoleUser.joins(:user).where("users.email=?", email).map(&:project_id)) }
  scope :program_admins_ends_with, -> (email) { where(id: RoleUser.joins(:user).where("users.email LIKE ?", "%#{email}").map(&:project_id)) }
  scope :program_admins_starts_with, -> (email) { where(id: RoleUser.joins(:user).where("users.email LIKE ?", "#{email}%").map(&:project_id)) }

  # Program admins are those who has any of RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES roles for this program
  # i.e. check Role#get_program_admins 
  attr_accessor :admin_program_admins

  def default_facility_group
    create_default_facility_group
  end
  
  def list_default_facility_group_ids
    self.project_groups.where(is_default: true).pluck(:id).uniq
  end

  # def create_default_facility_group
  #   g = self.project_facility_groups.where(is_default: true).first
  #   if !g
  #     group = FacilityGroup.create(name: "Unassigned", owner_id: self.id, owner_type: self.class.name, is_default: true)
  #     g = self.project_facility_groups.create(facility_group_id: group.id)
  #   end
  #   g.project_group
  # end
  def create_default_facility_group
    g = self.project_groups.where(is_default: true).first
    if !g
      g = FacilityGroup.create(name: "Unassigned", owner_id: self.id, owner_type: self.class.name, is_default: true)
      pg = self.project_facility_groups.create(facility_group_id: g.id)
    end
    g
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:program_admins_equals, :program_admins_ends_with, :program_admins_starts_with, :program_admins_contains]
  end

  def as_json(options=nil)
    json = super(options)
    json.merge(
      project_type: self.project_type.try(:name)
    ).as_json
  end

  def check_min_program_admins
    if self.persisted?
      role_id = Role.program_admin_user_role.id
      role_user_count = RoleUser.where(role_id: role_id, project_id: self.id).count
      if role_user_count < 1
        self.errors.add(:base, "There must be at least one program admin assigned")
        return false
      end
    else
      if !admin_program_admins || admin_program_admins.reject { |c| c.empty? }.size < 1
        self.errors.add(:base, "There must be at least one program admin assigned")
        return false
      end
    end
  end

  def get_program_admins(role_id = nil)
    if !role_id
      role_id = Role.program_admin_user_role.id
    end
    user_ids = role_users.select{|ru| ru.role_id == role_id }.map(&:user_id).compact.uniq
    users.select{|user| user_ids.include?(user.id)}
    
    # User.joins(:role_users).where("role_users.role_id": role_id, "role_users.project_id": self.id)
  end

  def get_program_admin_ids
    get_program_admins.map(&:id)
  end

  def total_progress
    project = self
    task_count = project.tasks.size
    task_sum = project.tasks.sum("tasks.progress")
    task_weight = ( task_count * (task_sum / task_count) ) rescue 0
    
    issue_count = project.issues.size
    issue_sum = project.issues.sum("issues.progress")
    issue_weight = issue_count * (issue_sum / issue_count) rescue 0

    risk_count = project.risks.size
    risk_sum = project.risks.sum("risks.progress")
    risk_weight = risk_count * (risk_sum / risk_count).to_f rescue 0

    ( (task_weight.to_f + issue_weight.to_f + risk_weight.to_f) / (task_count.to_f + issue_count.to_f + risk_count.to_f) ).round rescue 0
  end

  def portfolio_json
    { 
      id: id, 
      name: name,
      progress: total_progress
    }
  end  

  def as_complete_json
    as_json.merge(
      users: users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email,:status ]),
      facilities: facility_projects.includes(include_fp_hash, :status).active.uniq.as_json,
      facility_groups: facility_groups.includes(include_fg_hash).active.uniq.as_json,
      statuses: statuses.as_json,
      task_types: task_types.as_json,
      issue_types: issue_types.as_json,
      issue_severities: issue_severities.as_json,
      task_stages: task_stages.as_json,
      issue_stages: issue_stages.as_json,
      risk_stages: risk_stages.as_json
    )
  end
  
  def build_json_response(user, response_for: 'client_panel')
    project = self
    all_facility_projects = []
    all_facility_project_ids = []
    all_facility_ids = []
    all_project_contract_ids = []
    all_project_contract_vehicle_ids = []

    if response_for == 'program_settings'
      all_facility_projects = FacilityProject.includes(:tasks, :status,:facility).where(project_id: project.id, facility: {status: :active})
      all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
      all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq
      all_project_contract_ids = ProjectContract.where(project_id: project.id).map(&:id).compact.uniq
      all_project_contract_vehicle_ids = ProjectContractVehicle.where(project_id: project.id).map(&:id).compact.uniq

    elsif response_for == 'client_panel'
      authorized_facility_project_ids = user.authorized_facility_project_ids(project_ids: [project.id])
      all_facility_projects = FacilityProject.includes(:tasks, :status,:facility).where(id: authorized_facility_project_ids, facility: {status: :active})
      all_facility_project_ids = authorized_facility_project_ids
      all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq
      all_project_contract_ids = user.authorized_contract_ids(project_ids: [project.id])
      all_project_contract_vehicle_ids = user.authorized_contract_vehicle_ids(project_ids: [project.id])
    end

    facility_project_ids_with_project_tasks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_TASKS).select("distinct(facility_project_id)").map(&:facility_project_id)

    facility_project_ids_with_project_issues = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_ISSUES).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    facility_project_ids_with_project_risks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_RISKS).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    facility_project_ids_with_project_lessons = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_LESSONS).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    facility_project_ids_with_project_notes = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id in (?) and role_privileges.role_type = ?", all_facility_project_ids, RolePrivilege::PROJECT_NOTES).select("distinct(facility_project_id)").map(&:facility_project_id)
    
    project_contract_ids_with_contract_tasks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id in (?) and role_privileges.role_type = ?", all_project_contract_ids, RolePrivilege::CONTRACT_TASKS).select("distinct(project_contract_id)").map(&:project_contract_id)
    
    project_contract_ids_with_contract_issues = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id in (?) and role_privileges.role_type = ?", all_project_contract_ids, RolePrivilege::CONTRACT_ISSUES).select("distinct(project_contract_id)").map(&:project_contract_id)
    
    project_contract_ids_with_contract_risks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id in (?) and role_privileges.role_type = ?", all_project_contract_ids, RolePrivilege::CONTRACT_RISKS).select("distinct(project_contract_id)").map(&:project_contract_id)
    
    project_contract_ids_with_contract_lessons = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id in (?) and role_privileges.role_type = ?", all_project_contract_ids, RolePrivilege::CONTRACT_LESSONS).select("distinct(project_contract_id)").map(&:project_contract_id)
    
    project_contract_ids_with_contract_notes = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id in (?) and role_privileges.role_type = ?", all_project_contract_ids, RolePrivilege::CONTRACT_NOTES).select("distinct(project_contract_id)").map(&:project_contract_id)


    project_contract_vehicle_ids_with_contract_tasks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_vehicle_id in (?) and role_privileges.role_type = ?", all_project_contract_vehicle_ids, RolePrivilege::CONTRACT_TASKS).select("distinct(project_contract_vehicle_id)").map(&:project_contract_vehicle_id)
    
    project_contract_vehicle_ids_with_contract_issues = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_vehicle_id in (?) and role_privileges.role_type = ?", all_project_contract_vehicle_ids, RolePrivilege::CONTRACT_ISSUES).select("distinct(project_contract_vehicle_id)").map(&:project_contract_vehicle_id)
    
    project_contract_vehicle_ids_with_contract_risks = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_vehicle_id in (?) and role_privileges.role_type = ?", all_project_contract_vehicle_ids, RolePrivilege::CONTRACT_RISKS).select("distinct(project_contract_vehicle_id)").map(&:project_contract_vehicle_id)
    
    # project_contract_vehicle_ids_with_contract_lessons = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_vehicle_id in (?) and role_privileges.role_type = ?", all_project_contract_vehicle_ids, RolePrivilege::CONTRACT_LESSONS).select("distinct(project_contract_vehicle_id)").map(&:project_contract_vehicle_id)
    
    project_contract_vehicle_ids_with_contract_notes = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_vehicle_id in (?) and role_privileges.role_type = ?", all_project_contract_vehicle_ids, RolePrivilege::CONTRACT_NOTES).select("distinct(project_contract_vehicle_id)").map(&:project_contract_vehicle_id)


    all_users = []
    all_user_ids = []

    all_tasks = Task.unscoped.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :contract_facility_group, :contract_project, :project, :contract_project_data, :contract_vehicle, {facility_project: :facility} ]).where("tasks.facility_project_id in (?) or tasks.project_contract_id in (?) or tasks.project_contract_vehicle_id in (?)", facility_project_ids_with_project_tasks, project_contract_ids_with_contract_tasks, project_contract_vehicle_ids_with_contract_tasks).sort{ |t1,t2| (t1.due_date && t2.due_date) ? (t1.due_date <=> t2.due_date) : ( t1.due_date ? -1 : 1 ) }
    
    all_task_users = TaskUser.where(task_id: all_tasks.map(&:id) ).group_by(&:task_id)
    all_user_ids += all_task_users.values.flatten.map(&:user_id)

    all_issues = Issue.unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :project, :contract_facility_group, :contract_project, :contract_project_data, :contract_vehicle, {facility_project: :facility}, :issue_severity ]).where("issues.facility_project_id in (?) or issues.project_contract_id in (?) or issues.project_contract_vehicle_id in (?)", facility_project_ids_with_project_issues, project_contract_ids_with_contract_issues, project_contract_vehicle_ids_with_contract_issues)
    all_issue_users = IssueUser.where(issue_id: all_issues.map(&:id) ).group_by(&:issue_id)
    all_user_ids += all_issue_users.values.flatten.map(&:user_id)

    all_risks = Risk.unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :project, :contract_facility_group, :contract_project, :contract_project_data, :contract_vehicle, {facility_project: :facility} ]).where("risks.facility_project_id in (?) or risks.project_contract_id in (?)  or risks.project_contract_vehicle_id in (?)", facility_project_ids_with_project_risks, project_contract_ids_with_contract_risks, project_contract_vehicle_ids_with_contract_risks).sort{ |r1,r2| (r1.due_date && r2.due_date) ? (r1.due_date <=> r2.due_date) : ( r1.due_date ? -1 : 1 ) }
    all_risk_users = RiskUser.where(risk_id: all_risks.map(&:id) ).group_by(&:risk_id)
    all_user_ids += all_risk_users.values.flatten.map(&:user_id)

    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization, :facility_projects, :role_users, :role_privileges).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    all_notes = Note.unscoped.includes([{note_files_attachments: :blob}, :user]).where(noteable_id: facility_project_ids_with_project_notes, noteable_type: "FacilityProject")

    project_contract_ids = all_project_contract_ids

    all_notes += Note.unscoped.includes([{note_files_attachments: :blob}, :user]).where(noteable_id: project_contract_ids_with_contract_notes, noteable_type: "ProjectContract")
    all_project_contracts = ProjectContract.includes(:contract_project_datum).where(id: project_contract_ids)
    all_contract_poject_data = ContractProjectDatum.where(id: all_project_contracts.pluck(:contract_project_datum_id).uniq )

    all_notes += Note.unscoped.includes([{note_files_attachments: :blob}, :user]).where(noteable_id: project_contract_vehicle_ids_with_contract_notes, noteable_type: "ProjectContractVehicle")
    all_project_contract_vehicles = ProjectContractVehicle.includes(:contract_vehicle, :facility_group).where(id: all_project_contract_vehicle_ids)
    all_contract_vehicle_poject_data = ContractVehicle.where(id: all_project_contract_vehicles.pluck(:contract_vehicle_id).uniq )


    all_contracts = []

    all_facilities = Facility.where(id: all_facility_ids)
    all_facility_group_ids = (all_facility_projects.map(&:facility_group_id) + all_project_contracts.map(&:facility_group_id) ).compact.uniq
    all_facility_group_ids = (all_facility_group_ids + project.project_facility_groups.pluck(:facility_group_id) ).compact.uniq
    all_facility_groups = FacilityGroup.includes(:facilities, :facility_projects, :project_contracts, :project_facility_groups, :project_contract_vehicles).where("id in (?)", all_facility_group_ids)

    facility_projects_hash = []
    facility_projects_hash2 = {}

    project_type_name = project.project_type.try(:name)

    # NOTE: remove this code, because now we are using roles based permission
    pph = {} #user.project_privileges_hash
    fph = {} #user.facility_privileges_hash
    cph = {} #user.contract_privileges_hash[project.id.to_s] || {}

    all_facility_projects.each do |fp|

      facility = all_facilities.detect{|f| f.id == fp.facility_id}

      next if !facility

      h = fp.attributes.merge({
        class: fp.class.name,
        project_status: fp.status_name,
        color: fp.color,
        progress: fp.progress,
        facility_project_id: fp.id,
        facility_name: facility.facility_name
      })

      g = all_facility_groups.detect{|gg| gg.id == fp.facility_group_id}

      h[:facility] = facility.attributes.merge({
        facility_group_id: g&.id,
        facility_group_name: g&.name,
        facility_group_status: g&.status,
        project_id: fp.project_id
      })

      # Building Tasks
      tasks = all_tasks.select{|t| t.facility_project_id == fp.id }.compact.uniq

      h[:tasks] = []
      tasks.each do |t| 
        h[:tasks] << t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
      end

      # Building Issues
      issues = all_issues.select{|i| i.facility_project_id == fp.id}

      h[:issues] = []
      issues.each do |i| 
        h[:issues] << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
      end

      # Building Risks
      risks = all_risks.select{|r| r.facility_project_id == fp.id}
      h[:risks] = []
      risks.each do |r| 
        h[:risks] << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
      end

      # Building Notes
      notes = all_notes.select{|r| r.noteable_id == fp.id}

      h[:notes] = notes.map(&:to_json)

      facility_projects_hash2[fp.id] = h
      facility_projects_hash << h
    end

    contract_vehicle_hash = []
    project_contract_vehicle_hash2 = {}
    all_project_contract_vehicles.each do |pc|
      c = all_contract_vehicle_poject_data.detect{|cp| cp.id == pc.contract_vehicle_id }
      
      next if !c

      c_hash = c.to_json
      c_hash.merge!({project_contract_vehicle_id: pc.id,facility_group: pc.facility_group.as_json})

      c_hash[:tasks] = []
      if user.has_contract_permission?(resource: 'tasks', project_contract_vehicle: pc)
        tasks = all_tasks.select{|t| t.project_contract_vehicle_id == pc.id }.compact.uniq
        
        tasks.each do |t| 
          c_hash[:tasks] << t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
        end
      end

      c_hash[:issues] = []
      if user.has_contract_permission?(resource: 'issues', project_contract_vehicle: pc)
        issues = all_issues.select{|t| t.project_contract_vehicle_id == pc.id }.compact.uniq
        issues.each do |i| 
          c_hash[:issues] << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
        end
      end

      c_hash[:risks] = []
      if user.has_contract_permission?(resource: 'risks', project_contract_vehicle: pc)
        risks = all_risks.select{|t| t.project_contract_vehicle_id == pc.id }.compact.uniq
        risks.each do |r| 
          c_hash[:risks] << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
        end
      end

      # Building Notes
      c_hash[:notes] = []
      if user.has_contract_permission?(resource: 'notes', project_contract_vehicle: pc)
        notes = all_notes.select{|r| r.noteable_id == pc.id}.compact.uniq
        c_hash[:notes] = notes.map(&:to_json)
      end

      project_contract_vehicle_hash2[pc.id] = c_hash
      contract_vehicle_hash << c_hash
    end

    contract_hash = []
    project_contract_hash2 = {}
    all_project_contracts.each do |pc|
      c = all_contract_poject_data.detect{|cp| cp.id == pc.contract_project_datum_id}
      
      next if !c

      c_hash = c.to_json({project_contract: pc})

      c_hash[:tasks] = []
      if user.has_contract_permission?(resource: 'tasks', project_contract: pc, project_privileges_hash: pph, contract_privileges_hash: cph)
        tasks = all_tasks.select{|t| t.project_contract_id == pc.id }.compact.uniq
        
        tasks.each do |t| 
          c_hash[:tasks] << t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
        end
      end

      c_hash[:issues] = []
      if user.has_contract_permission?(resource: 'issues', project_contract: pc, project_privileges_hash: pph, contract_privileges_hash: cph)
        issues = all_issues.select{|t| t.project_contract_id == pc.id }.compact.uniq
        issues.each do |i| 
          c_hash[:issues] << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
        end
      end

      c_hash[:risks] = []
      if user.has_contract_permission?(resource: 'risks', project_contract: pc, project_privileges_hash: pph, contract_privileges_hash: cph)
        risks = all_risks.select{|t| t.project_contract_id == pc.id }.compact.uniq
        risks.each do |r| 
          c_hash[:risks] << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
        end
      end

      # Building Notes
      c_hash[:notes] = []
      if user.has_contract_permission?(resource: 'notes', project_contract: pc, project_privileges_hash: pph, contract_privileges_hash: cph)
        notes = all_notes.select{|r| r.noteable_id == pc.id}.compact.uniq
        c_hash[:notes] = notes.map(&:to_json)
      end

      project_contract_hash2[pc.id] = c_hash
      contract_hash << c_hash
    end

    facility_groups_hash = []
    all_facility_groups.each do |fg|
      h2 = fg.attributes
      h2[:is_default] = fg.is_default
      h2[:facilities] = []
      h2[:project_ids] = []

      h2[:contracts] = []
      h2[:contract_project_ids] = []
      
      h2[:contract_vehicles] = []
      h2[:contract_vehicle_ids] = []

      fg.facility_projects.each do |fp|
        h2[:facilities] << facility_projects_hash2[fp.id] if facility_projects_hash2[fp.id]
        h2[:project_ids] << fp.project_id
        # h2[:project_ids] << fp.facility_id
      end
      h2[:project_ids] = h2[:project_ids].compact.uniq

      fg.project_contracts.each do |pc|
        h2[:contracts] << project_contract_hash2[pc.id] if project_contract_hash2[pc.id]
        h2[:contract_project_ids] << pc.project_id
      end

      fg.project_contract_vehicles.each do |pc|
        h2[:contract_vehicles] << project_contract_vehicle_hash2[pc.id] if project_contract_vehicle_hash2[pc.id]
        h2[:contract_vehicle_ids] << pc.project_id
      end

      facility_groups_hash << h2
    end

    hash = project.attributes.merge({project_type: project_type_name})

    hash.merge!({
      #users: users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email,:status ]),
      users: users.as_json({only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email,:status ], all_organizations: all_organizations}),
      facilities: facility_projects_hash,
      contracts: contract_hash,
      contract_vehicles: contract_vehicle_hash,
      facility_groups: facility_groups_hash,
      statuses: statuses.as_json(except: [:created_at, :updated_at]),
      task_types: task_types.as_json,
      issue_types: issue_types.as_json,
      issue_severities: issue_severities.as_json,
      task_stages: task_stages.as_json,
      issue_stages: issue_stages.as_json,
      risk_stages: risk_stages.as_json,
      lesson_stages: lesson_stages.as_json,
      contract_types: ContractType.all.as_json,
      contract_statues: ContractStatus.all.as_json,
      contract_customers: ContractCustomer.all.as_json,
      # contract_vehicles: ContractVehicle.all.as_json,
      contract_vehicle_numbers: ContractVehicleNumber.all.as_json,
      contract_numbers: ContractNumber.all.as_json,
      subcontract_numbers: SubcontractNumber.all.as_json,
      contract_primes: ContractPrime.all.as_json,
      contract_current_pops: ContractCurrentPop.all.as_json,
      contract_classifications: ContractClassification.all.as_json
    })

    hash
  end

  def add_not_started_status
    if !self.statuses.exists?(id: Status.not_started.id)
      self.statuses << Status.not_started
    end
  end

  def reject_comment(comment)
    comment['body'].blank?
  end
  
  def update_progress
    t = self.tasks
    p = 0
    if t.any?
      p = (t.map(&:progress).sum / t.size).round(0)
    end
    self.update(progress: p)
  end

  # def progress
  #   self.tasks.map(&:progress).sum / self.tasks.count rescue 0
  # end

  def delete_nested_facilities ids
    ids = ids.reject(&:blank?)
    facility_projects.where.not(facility_id: ids).destroy_all
  end

  attr_accessor :user_alt
  attr_accessor :facility_alt
  attr_accessor :status_alt
  attr_accessor :task_type_alt
  attr_accessor :issue_type_alt
  attr_accessor :issue_severity_alt
  attr_accessor :task_stage_alt
  attr_accessor :issue_stage_alt

  private
    def set_uuid
      self.uuid = SecureRandom.uuid
    end

    def grant_access_to_admins
      self.users << User.superadmin.where.not(id: self.users.ids)
    end

    def include_fp_hash
      {
        facility: [:facility_group],
        risks: [{risk_files_attachments: :blob}, :user, :checklists, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, {facility_project: :facility} ],
        tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ],
        issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ],
        notes: [{note_files_attachments: :blob}, :user]
      }
    end

    def include_fg_hash
      {
        facility_projects: [:facility, {
          tasks: [{task_files_attachments: :blob}, :task_type, :users, :task_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility} ]
          }, {
          issues: [{issue_files_attachments: :blob}, :issue_type, :users, :issue_stage, :checklists, :notes, :related_tasks, :related_issues, :sub_tasks, :sub_issues, {facility_project: :facility}, :issue_severity ]
          }, {
            notes: [{note_files_attachments: :blob}, :user]
          }
        ]
      }
    end
end
