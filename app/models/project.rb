#NOTE: Project is now program in front end

class Project < SortableRecord
  # default_scope {order(Project.order_humanize)}
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :facility_projects, dependent: :destroy
  has_many :facilities, through: :facility_projects
  has_many :facility_groups, through: :facilities
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

  enum status: [:inactive, :active].freeze

  validates_uniqueness_of :name, case_sensitive: false
  validates :name, presence: true

  before_create :set_uuid
  after_save :grant_access_to_admins
  after_save :add_not_started_status

  def as_json(options=nil)
    json = super(options)
    json.merge(
      project_type: self.project_type.try(:name)
    ).as_json
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
    json = as_json.merge(
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
    json
  end

  def build_json_response_for_user_profile
    all_facility_projects = FacilityProject.includes(:tasks).where(project_id: self.id)
    all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
    all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq

    all_facilities = Facility.where(id: all_facility_ids)
    all_facility_group_ids = all_facilities.map(&:facility_group_id).compact.uniq
    all_facility_groups = FacilityGroup.includes(:facilities, :facility_projects).where(id: all_facility_group_ids)

    facility_projects_hash = []
    facility_projects_hash2 = {}

    project_type_name = self.project_type.try(:name)

    all_facility_projects.each do |fp|

      facility = all_facilities.detect{|f| f.id == fp.facility_id}

      h = fp.attributes.merge({
        class: fp.class.name,
        project_status: fp.status_name,
        color: fp.color,
        progress: fp.progress,
        facility_project_id: fp.id,
        facility_name: facility.facility_name
      })

      g = all_facility_groups.detect{|gg| gg.id == facility.facility_group_id}

      h[:facility] = facility.attributes.merge({
        facility_group_name: g&.name,
        facility_group_status: g&.status,
      })

      facility_projects_hash2[fp.id] = h
      facility_projects_hash << h
    end

    facility_groups_hash = []
    all_facility_groups.each do |fg|
      h2 = fg.attributes
      h2[:facilities] = []
      h2[:project_ids] = []
      fg.facility_projects.each do |fp|
        h2[:facilities] << facility_projects_hash2[fp.id] if facility_projects_hash2[fp.id]
        h2[:project_ids] << fp.project_id
      end
      h2[:project_ids] = h2[:project_ids].compact.uniq
      facility_groups_hash << h2
    end

    hash = self.attributes.merge({project_type: project_type_name})

    hash.merge!({
      facilities: facility_projects_hash,
      facility_groups: facility_groups_hash
    })

    hash
  end

  def build_json_response_for_portfolio(resource_name, user)
    all_facility_projects = FacilityProject.includes(:tasks, :status,:facility).where(project_id: self.id, facility: {status: :active})
    all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
    all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq

    all_facility_projects = FacilityProject.includes(:tasks, :status,:facility).where(project_id: self.id, facility: {status: :active})
    all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
    all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq

    all_users = []
    all_user_ids = []
    resource_objects = []

    if resource_name == "tasks"
      all_tasks = Task.unscoped.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility} ]).where(facility_project_id: all_facility_project_ids).sort{ |t1,t2| (t1.due_date && t2.due_date) ? (t1.due_date <=> t2.due_date) : ( t1.due_date ? -1 : 1 ) }
      all_task_users = TaskUser.where(task_id: all_tasks.map(&:id) ).group_by(&:task_id)
      all_user_ids += all_task_users.values.flatten.map(&:user_id)
    end
    
    if resource_name == "issues"
      all_issues = Issue.unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility}, :issue_severity ]).where(facility_project_id: all_facility_project_ids)
      all_issue_users = IssueUser.where(issue_id: all_issues.map(&:id) ).group_by(&:issue_id)
      all_user_ids += all_issue_users.values.flatten.map(&:user_id)
    end

    if resource_name == "risks"
      all_risks = Risk.unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, {facility_project: :facility} ]).where(facility_project_id: all_facility_project_ids).sort{ |r1,r2| (r1.due_date && r2.due_date) ? (r1.due_date <=> r2.due_date) : ( r1.due_date ? -1 : 1 ) }
      all_risk_users = RiskUser.where(risk_id: all_risks.map(&:id) ).group_by(&:risk_id)
      all_user_ids += all_risk_users.values.flatten.map(&:user_id)
    end

    if resource_name == "lessons"
      all_lessons = Lesson.unscoped.includes(Lesson.lesson_preload_array).where(facility_project_id: all_facility_project_ids)
    end

    if resource_name == "notes"
      all_notes = Note.unscoped.where(noteable_id: all_facility_project_ids, noteable_type: "FacilityProject")
    end

    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    all_facilities = Facility.includes(:facility_group).where(id: all_facility_ids)

    if resource_name == "projects"
      all_facilities.find_each{|f| resource_objects << f}
      return resource_objects
    end    

    pph = user.project_privileges_hash
    fph = user.facility_privileges_hash

    all_facility_projects.each do |fp|

      facility = all_facilities.detect{|f| f.id == fp.facility_id}

      next if !facility
      
      if resource_name == "tasks"
        # Building Tasks
        # tasks = all_tasks.select{|t| t.facility_project_id == fp.id }.compact.uniq
        # h[:tasks] = tasks.map(&:to_json)
        tasks = []
        if user.has_permission?(resource: 'tasks', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          tasks = all_tasks.select{|t| t.facility_project_id == fp.id }.compact.uniq
        end

        tasks.each do |t| 
          resource_objects << t.portfolio_json #t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
        end

      end

      if resource_name == "issues"
        # Building Issues
        # issues = all_issues.select{|i| i.facility_project_id == fp.id}
        # h[:issues] = issues.map(&:to_json)
        issues = []
        if user.has_permission?(resource: 'issues', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          issues = all_issues.select{|t| t.facility_project_id == fp.id }.compact.uniq
        end

        issues.each do |i| 
          resource_objects << i.portfolio_json #i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
        end
      end

      if resource_name == "risks"
        # Building Risks
        # risks = all_risks.select{|r| r.facility_project_id == fp.id}
        # h[:risks] = risks.map(&:to_json)
        risks = []
        if user.has_permission?(resource: 'risks', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          risks = all_risks.select{|t| t.facility_project_id == fp.id }.compact.uniq
        end

        risks.each do |r| 
          resource_objects << r.portfolio_json #r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
        end
      end

      if resource_name == "lessons"
        # Building Lessons
        lessons = []
        if user.has_permission?(resource: 'lessons', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          lessons = all_lessons.select{|t| t.facility_project_id == fp.id }.compact.uniq
        end

        lessons.each do |r| 
          resource_objects << r.portfolio_json #r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
        end
      end

      if resource_name == "notes"
        # Building Notes
        notes = []
        if user.has_permission?(resource: 'notes', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
          notes = all_notes.select{|r| r.noteable_id == fp.id}
        end

        resource_objects += notes.map(&:portfolio_json)
      end

    end

    resource_objects
  end
  
  def build_json_response(user)
    project = self
    all_facility_projects = FacilityProject.includes(:tasks, :status,:facility).where(project_id: project.id, facility: {status: :active})
    all_facility_project_ids = all_facility_projects.map(&:id).compact.uniq
    all_facility_ids = all_facility_projects.map(&:facility_id).compact.uniq
    all_authorized_contract_ids = user.authorized_contract_ids

    all_users = []
    all_user_ids = []

    all_tasks = Task.unscoped.includes([{task_files_attachments: :blob}, :task_type, :task_users, {users: :organization}, :task_stage, {checklists: [:user, {progress_lists: :user} ] }, { notes: :user }, :related_tasks, :related_issues, :related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :contract_facility_group, :contract_project, :project, {facility_project: :facility} ]).where("tasks.facility_project_id in (?) or tasks.contract_id in (?)", all_facility_project_ids, all_authorized_contract_ids).sort{ |t1,t2| (t1.due_date && t2.due_date) ? (t1.due_date <=> t2.due_date) : ( t1.due_date ? -1 : 1 ) }
    
    all_task_users = TaskUser.where(task_id: all_tasks.map(&:id) ).group_by(&:task_id)
    all_user_ids += all_task_users.values.flatten.map(&:user_id)

    all_issues = Issue.unscoped.includes([{issue_files_attachments: :blob}, :issue_type, :task_type, :issue_users, {users: :organization}, :issue_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :project, :contract_facility_group, :contract_project, {facility_project: :facility}, :issue_severity ]).where("issues.facility_project_id in (?) or issues.contract_id in (?)", all_facility_project_ids, all_authorized_contract_ids)
    all_issue_users = IssueUser.where(issue_id: all_issues.map(&:id) ).group_by(&:issue_id)
    all_user_ids += all_issue_users.values.flatten.map(&:user_id)

    all_risks = Risk.unscoped.includes([{risk_files_attachments: :blob}, :task_type, :risk_users, {user: :organization},:risk_stage, {checklists: [:user, {progress_lists: :user} ] },  { notes: :user }, :related_tasks, :related_issues,:related_risks, :sub_tasks, :sub_issues, :sub_risks, :facility_group, :project, :contract_facility_group, :contract_project, {facility_project: :facility} ]).where("risks.facility_project_id in (?) or risks.contract_id in (?)", all_facility_project_ids, all_authorized_contract_ids).sort{ |r1,r2| (r1.due_date && r2.due_date) ? (r1.due_date <=> r2.due_date) : ( r1.due_date ? -1 : 1 ) }
    all_risk_users = RiskUser.where(risk_id: all_risks.map(&:id) ).group_by(&:risk_id)
    all_user_ids += all_risk_users.values.flatten.map(&:user_id)

    all_user_ids = all_user_ids.compact.uniq

    all_users = User.includes(:organization).where(id: all_user_ids ).active
    all_organizations = Organization.where(id: all_users.map(&:organization_id).compact.uniq )

    all_notes = Note.unscoped.includes([{note_files_attachments: :blob}, :user]).where(noteable_id: all_facility_project_ids, noteable_type: "FacilityProject")
    all_facilities = Facility.where(id: all_facility_ids)
    all_facility_group_ids = all_facilities.map(&:facility_group_id).compact.uniq
    all_facility_groups = FacilityGroup.includes(:facilities, :facility_projects).where("id in (?) or project_id = ?", all_facility_group_ids, project.id)

    all_contracts = Contract.where(facility_group_id: all_facility_group_ids, project_id: project.id, id: user.authorized_contract_ids(project_ids: [project.id]) ).group_by(&:facility_group_id)

    facility_projects_hash = []
    facility_projects_hash2 = {}

    project_type_name = project.project_type.try(:name)

    pph = user.project_privileges_hash
    fph = user.facility_privileges_hash
    cph = user.contract_privileges_hash[project.id] || {}

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

      g = all_facility_groups.detect{|gg| gg.id == facility.facility_group_id}

      h[:facility] = facility.attributes.merge({
        facility_group_name: g&.name,
        facility_group_status: g&.status,
      })

      # Building Tasks
      # tasks = all_tasks.select{|t| t.facility_project_id == fp.id }.compact.uniq
      # h[:tasks] = tasks.map(&:to_json)
      tasks = []
      if user.has_permission?(resource: 'tasks', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
        tasks = all_tasks.select{|t| t.facility_project_id == fp.id }.compact.uniq
        tids = tasks.map(&:id)
      end

      h[:tasks] = []
      tasks.each do |t| 
        h[:tasks] << t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
      end

      # Building Issues
      # issues = all_issues.select{|i| i.facility_project_id == fp.id}
      # h[:issues] = issues.map(&:to_json)
      issues = []
      if user.has_permission?(resource: 'issues', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
        issues = all_issues.select{|t| t.facility_project_id == fp.id }.compact.uniq
        iids = issues.map(&:id)
      end

      h[:issues] = []
      issues.each do |i| 
        h[:issues] << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
      end

      # Building Risks
      # risks = all_risks.select{|r| r.facility_project_id == fp.id}
      # h[:risks] = risks.map(&:to_json)
      risks = []
      if user.has_permission?(resource: 'risks', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
        risks = all_risks.select{|t| t.facility_project_id == fp.id }.compact.uniq
        rids = risks.map(&:id)
      end

      h[:risks] = []
      risks.each do |r| 
        h[:risks] << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
      end

      # Building Notes
      notes = []
      if user.has_permission?(resource: 'notes', program: fp.project_id, project: fp.facility_id, project_privileges_hash: pph, facility_privileges_hash: fph)
        notes = all_notes.select{|r| r.noteable_id == fp.id}
      end

      h[:notes] = notes.map(&:to_json)

      facility_projects_hash2[fp.id] = h
      facility_projects_hash << h
    end

    facility_groups_hash = []
    all_facility_groups.each do |fg|
      h2 = fg.attributes
      h2[:facilities] = []
      h2[:project_ids] = []
      h2[:contracts] = []

      contracts = (all_contracts[fg.id] || [])      
      contracts.each do |c|
        c_hash = c.to_json

        if user.has_contract_permission?(resource: 'tasks', contract: c, project_privileges_hash: pph, contract_privileges_hash: cph)
          tasks = all_tasks.select{|t| t.contract_id == c.id }.compact.uniq
          c_hash[:tasks] = []
          tasks.each do |t| 
            c_hash[:tasks] << t.to_json({orgaizations: all_organizations, all_task_users: all_task_users[t.id], all_users: all_users, for: :project_build_response} )
          end
        end

        if user.has_contract_permission?(resource: 'issues', contract: c, project_privileges_hash: pph, contract_privileges_hash: cph)
          issues = all_issues.select{|t| t.contract_id == c.id }.compact.uniq
          c_hash[:issues] = []
          issues.each do |i| 
            c_hash[:issues] << i.to_json( {orgaizations: all_organizations, all_issue_users: all_issue_users[i.id], all_users: all_users,for: :project_build_response} )
          end
        end

        if user.has_contract_permission?(resource: 'issues', contract: c, project_privileges_hash: pph, contract_privileges_hash: cph)
          risks = all_risks.select{|t| t.contract_id == c.id }.compact.uniq
          c_hash[:risks] = []
          risks.each do |r| 
            c_hash[:risks] << r.to_json( {orgaizations: all_organizations, all_risk_users: all_risk_users[r.id], all_users: all_users, for: :project_build_response} )
          end
        end


        h2[:contracts] << c_hash
      end
      # h2[:contracts] = (all_contracts[fg.id] || []).map(&:to_json)

      fg.facility_projects.each do |fp|
        h2[:facilities] << facility_projects_hash2[fp.id] if facility_projects_hash2[fp.id]
        # h2[:project_ids] << fp.project_id
        h2[:project_ids] << fp.facility_id
      end
      h2[:project_ids] = h2[:project_ids].compact.uniq
      facility_groups_hash << h2
    end

    hash = project.attributes.merge({project_type: project_type_name})

    hash.merge!({
      #users: users.as_json(only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email,:status ]),
      users: users.as_json({only: [:id, :full_name, :title, :phone_number, :first_name, :last_name, :email,:status ], all_organizations: all_organizations}),
      facilities: facility_projects_hash,
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
      contract_vehicles: ContractVehicle.all.as_json,
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
