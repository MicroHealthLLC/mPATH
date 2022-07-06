class User < ApplicationRecord
  
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :facilities
  has_many :facility_projects, through: :projects
  has_many :risks
  has_one :privilege, dependent: :destroy
  belongs_to :organization, optional: true
  has_many :query_filters, dependent: :destroy
  has_many :contract_privileges, dependent: :destroy
  has_many :facility_privileges, dependent: :destroy
  has_many :project_privileges, dependent: :destroy
  has_many :contracts
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users
  has_many :role_privileges, through: :roles
  validates :first_name, :last_name, presence: true
  validate :password_complexity
  before_commit :set_color, on: :create
  after_create :provide_view_privileges

  enum role: [:client, :superadmin].freeze
  enum status: [:inactive, :active].freeze

  scope :admin, -> {joins(:privilege).where("privileges.admin LIKE ? OR role = ?", "%R%", 1).distinct}

  accepts_nested_attributes_for :privilege, reject_if: :all_blank
  accepts_nested_attributes_for :facility_privileges, reject_if: proc { |attributes| attributes['facility_project_ids'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :contract_privileges, reject_if: proc { |attributes| attributes['contract_ids'].blank? }, allow_destroy: true

  accepts_nested_attributes_for :project_privileges, reject_if: :all_blank, allow_destroy: true

  PREFERENCES_HASH =  {
      navigation_menu: 'map', 
      sub_navigation_menu: nil,
      program_id: nil, 
      project_id: nil,
      project_group_id: nil
    }
  has_settings do |s|
    s.key :preferences, defaults: PREFERENCES_HASH
  end

  def can_contract_data?(permission = 'read')
    privilege = self.privilege || Privilege.new
    if permission == 'read'
      privilege.contract_data && privilege.contract_data.chars.include?("R")
    elsif permission == 'write'
      privilege.contract_data && privilege.contract_data.chars.include?("W")
    elsif permission == 'delete'
      privilege.contract_data && privilege.contract_data.chars.include?("D")
    else
      false
    end
  end

  def can_read_contract_data?
    can_contract_data?('read')
  end

  def can_write_contract_data?
    can_contract_data?('write')
  end

  def can_delete_contract_data?
    can_contract_data?('delete')
  end

  def can_access_contract_data?
    can_read_contract_data? || can_write_contract_data? || can_delete_contract_data?
  end

  def provide_view_privileges
    user = self
    privilege = user.privilege || user.create_privilege
    if !privilege.map_view.present? && !privilege.gantt_view.present? && !privilege.members.present? && !privilege.sheets_view.present? && !privilege.kanban_view.present? && !privilege.calendar_view.present?
      privilege.update( {"map_view": ["R"], "gantt_view": ["R"],  "members": ["R"], "sheets_view": ["R"], "kanban_view": ["R"], "calendar_view": ["R"]})
    end    
  end

  def provide_program_privileges
    user = self
    return if !user.project_ids.any?
    privilege = user.privilege || Privilege.new
    privilege_attr = privilege.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "portfolio_view", "facility_manager_view","map_view", "gantt_view", "watch_view", "documents", "members", "settings_view", "sheets_view", "kanban_view", "calendar_view", "admin" ).clone
    privilege_attr.each do |k,v|
      privilege_attr[k] = ["R"]
    end
    user_project_privileges = user.project_privileges
    project_to_create_privileges = []
    user.project_ids.each do |pid|
      p = user_project_privileges.detect{|p| p.project_ids.map(&:to_i).include?(pid) }
      if !p
        project_to_create_privileges << pid
      end
    end
    if project_to_create_privileges.any?
      privilege_attr.merge!(user_id: user.id, project_ids: project_to_create_privileges.map(&:to_s))
      p = ProjectPrivilege.create(privilege_attr)
    end

  end

  def authorized_facility_project_id_hash
    # create has with allowed facility ids
    # h = {
    #   tasks: {read: [], write: [], destroy: []}, 
    #   risks: {read: [], write: [], destroy: []},
    #   lessons: {read: [], write: [], destroy: []},
    #   issues: {read: [], write: [], destroy: []},
    # }
    h = {
      tasks: [], 
      risks: [],
      lessons: [],
      issues: [],
    }
    fph = self.facility_privileges_hash
    program_ids = fph.keys
    facility_projects = FacilityProject.where(project_id: program_ids).pluck(:id, :project_id, :facility_id)

    fph.each do |program_id, hash|
      fps = facility_projects.select{|f| f[1] == program_id.to_i}
      hash.each do |facility_id, permissions|
        facility_project_id = fps.detect{|ff| ff[2] == facility_id.to_i}[0]
        next unless facility_project_id
        if permissions["tasks"] && permissions["tasks"].any?
          # h[:tasks][:read] << facility_project_id if   permissions["tasks"].include?("R")
          # h[:tasks][:write] << facility_project_id if   permissions["tasks"].include?("W")
          # h[:tasks][:destroy] << facility_project_id if   permissions["tasks"].include?("D")
          h[:tasks] << facility_project_id if (permissions["tasks"] & ["R", "W", "D"]).any?
        end
        if permissions["risks"] && permissions["risks"].any?
          # h[:risks][:read] << facility_project_id if   permissions["risks"].include?("R")
          # h[:risks][:write] << facility_project_id if   permissions["risks"].include?("W")
          # h[:risks][:destroy] << facility_project_id if   permissions["risks"].include?("D")
          h[:risks] << facility_project_id if (permissions["risks"] & ["R", "W", "D"]).any?
        end

        if permissions["lessons"] && permissions["lessons"].any?
          # h[:lessons][:read] << facility_project_id if   permissions["lessons"].include?("R")
          # h[:lessons][:write] << facility_project_id if   permissions["lessons"].include?("W")
          # h[:lessons][:destroy] << facility_project_id if   permissions["lessons"].include?("D")
          h[:lessons] << facility_project_id if (permissions["lessons"] & ["R", "W", "D"]).any?
        end
        if permissions["issues"] && permissions["issues"].any?
          # h[:issues][:read] << facility_project_id if   permissions["issues"].include?("R")
          # h[:issues][:write] << facility_project_id if   permissions["issues"].include?("W")
          # h[:issues][:destroy] << facility_project_id if   permissions["issues"].include?("D")
          h[:issues] << facility_project_id if (permissions["issues"] & ["R", "W", "D"]).any?

        end
      end
      h[:tasks].uniq!
      h[:risks].uniq!
      h[:lessons].uniq!
      h[:issues].uniq!
    end
    h
  end
  
  def authorized_program_ids
    # Project.where(id: self.project_privileges.pluck(:project_ids).flatten.uniq).includes([:facilities, :users, :tasks, :issues, :risks, :facility_projects ]).active.distinct
    # Project.where(id: self.project_privileges.pluck(:project_ids).flatten.uniq).active.distinct
    self.projects.active.pluck(:id)
  end

  def authorized_programs
    # Project.where(id: self.project_privileges.pluck(:project_ids).flatten.uniq).includes([:facilities, :users, :tasks, :issues, :risks, :facility_projects ]).active.distinct
    # Project.where(id: self.project_privileges.pluck(:project_ids).flatten.uniq).active.distinct
    self.projects.active
  end

  def full_name
    n = ''
    if self.first_name
      n += self.first_name
    end
    if self.last_name
      n += " #{self.last_name}"
    end
    n
  end

  def portfolio_json
    {
      id: id,
      full_name: full_name 
    }
  end

  def active_admin_facility_project_select_options
    fps_hash = FacilityProject.includes(:facility, :project).where(project_id: self.projects.active).group_by(&:project)
    options = []
    fps_hash.each do |project, fps|
      options << [project.name, project.id, {disabled: true}]
      fps.each do |f|
        options << ["&nbsp;#{f.facility.facility_name}".html_safe, f.id]
      end
    end    
    options
  end

  def active_admin_facility_project_select_options
    cps_hash = Contract.includes(:project).where(project_id: self.projects.active).group_by(&:project)
    options = []
    cps_hash.each do |project, cps|
      options << [project.name, project.id, {disabled: true}]
      cps.each do |c|
        options << ["&nbsp;#{c.nickname}".html_safe, c.id]
      end
    end    
    options
  end

  def active_admin_project_privilege_select_options
    fps_hash = self.projects.active
    options = []
    fps_hash.each do |project, fps|
      options << [project.name, project.id, {disabled: true}]
      fps.each do |f|
        options << ["&nbsp;#{f.facility.facility_name}".html_safe, f.id]
      end
    end    
    options
  end

  def remove_all_privileges(program_id)
    project_privileges = ProjectPrivilege.where(user_id: self.id)
    project_privileges.each do |project_privilege|
      project_privilege.project_ids = project_privilege.project_ids - [program_id.to_s]
      if !project_privilege.project_ids.any?
        project_privilege.destroy
      else
        project_privilege.save
      end
    end
    facility_privileges = FacilityPrivilege.where(user_id: self.id, project_id: program_id)
    facility_privileges.destroy_all if facility_privileges.any?
  end

  def encrypted_authentication_token
    self.save unless self.authentication_token.present?
    crypt = ActiveSupport::MessageEncryptor.new([ENV["MESSAGE_ENCRYPTOR_KEY"]].pack("H*"))
    return crypt.encrypt_and_sign(self.authentication_token)
  end
  
  def valid_encrypted_authentication_token?(token)
    return false unless self.authentication_token.present?
    crypt = ActiveSupport::MessageEncryptor.new([ENV["MESSAGE_ENCRYPTOR_KEY"]].pack("H*"))
    return crypt.decrypt_and_verify(token) == self.authentication_token rescue false
  end

  def allowed_navigation_tabs(right = 'R')
    nagivation_tabs = ["sheets_view", "map_view", "gantt_view", "kanban_view", "calendar_view", "members"]
    self.privilege ? nagivation_tabs & self.privilege.attributes.select{|k,v| v.is_a?(String) && v.include?(right)}.keys : []
  end

  def build_navigation_tabs_for_profile
    n = []
    allowed_navigation_tabs.each do |t|
      name = "sheet" if t == "sheets_view"
      # name = "settings" if t == "settings_view"
      next if t == "settings_view"
      name = "map" if t == "map_view"
      name = "gantt_chart" if t == "gantt_view"      
      name = "kanban" if t == "kanban_view"
      name = "calendar" if t == "calendar_view"
      name = "members" if t == "members"

      n << {id: name.downcase, name: name.humanize, value: name.downcase}
    end
    n
  end

  def allowed_sub_navigation_tabs(right = 'R')
    # sub_nagivation_tabs = ["tasks", "issues", "notes", "risks", "overview", "admin", "lessons"]
    # self.privilege.attributes.select{|k,v| v.is_a?(String) && v.include?(right)}.keys & sub_nagivation_tabs
    self.facility_privileges_hash.transform_values{|v| 
      v.transform_values{|v| 
        v.map{|k,v| 
          if (!["facility_id", "contracts"].include?(k)) && (v.present? || v.any?) && FacilityPrivilege::PRIVILEGE_MODULE[k.to_sym]
            {id: k.downcase, name: FacilityPrivilege::PRIVILEGE_MODULE[k.to_sym].humanize, value: k.downcase}
          end
        }.compact
      }
    } 
  end

  def build_sub_navigation_tabs_for_profile
    # allowed_sub_navigation_tabs.map{|s| {id: s.downcase, name: s.humanize, value: s.downcase} }
    allowed_sub_navigation_tabs
  end

  def build_sub_navigation_for_program_settings_tabs(right="R")
    h = Hash.new{|h,(k,v)| h[k] = [] }
    program_settings_privileges_hash.map do |k,v|
      v.each do |k1,v1|
        if v1.include?(right)
          puts k1
          h[k] << {id: k1.downcase, name: ProjectPrivilege::PRIVILEGE_MODULE[k1.to_sym], value: k1 } 
        end
      end
    end
    h
  end

  def top_navigation_hash
     {
      "sheets_view" => "sheet",  
      "settings_view" => "settings",
      "map_view" => "map",  
      "gantt_view" => "gantt_chart",  
      "kanban_view" => "kanban",  
      "calendar_view"  => "calendar",
      "members" => "members"
    }
  end

  def allowed_redirect_url(program_id)
    if !self.project_ids.include?(program_id)
      return Rails.application.routes.url_helpers.root_path
    else
      tab = top_navigation_hash[ ( allowed_navigation_tabs.first || "sheets_view")  ]
      return  "/programs/#{program_id}/#{tab}" 
    end
  end

  def preference_url
    p = self.get_preferences
    top_navigations = allowed_navigation_tabs
    current_top_navigation_menu = nil
    url = "/"
    navigation_menu = p.navigation_menu
    sub_navigation_menu = p.sub_navigation_menu
    sub_navigation_menu = FacilityPrivilege::PRIVILEGE_MODULE[sub_navigation_menu.to_sym] if sub_navigation_menu

    if p.program_id.present?
      url = "/programs/#{p.program_id}/sheet" # map must be
      if navigation_menu.present?
        navigtaion_present = false
        if top_navigations.include?( top_navigation_hash.invert[navigation_menu] )
          url = "/programs/#{p.program_id}/#{navigation_menu}"
          current_top_navigation_menu = navigation_menu
          navigtaion_present = true
          
          return url  if ["gantt_view", "members"].include?(top_navigation_hash.invert[navigation_menu])

        elsif top_navigations.size > 0
          url = "/programs/#{p.program_id}/#{top_navigation_hash[top_navigations.first]}"
          current_top_navigation_menu = top_navigations.first
          navigtaion_present = true
          return url  if ["gantt_view", "members"].include?(top_navigations.first)
        else
          url = ""
        end
        
        if navigtaion_present && p.project_id.present?
          if sub_navigation_menu.present?
            sub_navigation_privileges = facility_privileges_hash.dig(p.program_id.to_s, p.project_id.to_s ) || {}
            sub_navigation_privileges["analytics"] = sub_navigation_privileges["overview"] || []
            sub_navigation_allowed = sub_navigation_privileges[sub_navigation_menu].present?
            allowed_sub_navigation_values = sub_navigation_privileges.map{|key,value| key if value.is_a?(Array) && value.any? }.compact

            if sub_navigation_allowed

              # NOTE: calender_view don't have lessons tab so we will just allow tasks, issues and risks tab
              if current_top_navigation_menu == 'calendar_view'
                if  ["tasks", "issues", "risks"].include?(sub_navigation_menu)
                  url = "#{url}/projects/#{p.project_id}/#{sub_navigation_menu}"
                end
              else
                url = "#{url}/projects/#{p.project_id}/#{sub_navigation_menu}"
              end
            
            elsif allowed_sub_navigation_values.size > 0
            
              if current_top_navigation_menu == 'calendar_view'
                if  ["tasks", "issues", "risks"].include?(allowed_sub_navigation_values.first)
                  url = "#{url}/projects/#{p.project_id}/#{allowed_sub_navigation_values.first}"
                end
              else
                url = "#{url}/projects/#{p.project_id}/#{allowed_sub_navigation_values.first}"
              end
            end
          else
            url = "#{url}/projects/#{p.project_id}"
          end
        end
      end
    end
    url
  end

  def self.from_omniauth(auth)
    if where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").present?
      where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").first do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.first_name rescue nil
        user.last_name = auth.info.last_name rescue nil
        user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
        user.login = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
        user.first_name ||= user.login
        user.last_name ||= user.login
        user.password = Devise.friendly_token[0, 20]
      end
    else
      nil
    end
  end

  def password_complexity
    return unless self.changes.has_key?("password")
    pass_settings = JSON.parse(Setting['PASSWORDS_KEY'])
    error_message = []
    if password&.size < pass_settings['range'].to_i
      error_message.push "Length should be at least #{pass_settings['range']} characters"
    elsif pass_settings['uppercase']
      error_message.push "Should include 1 uppercase letter! " unless password =~ /^(?=.*?[A-Z]).{1,}$/
    elsif pass_settings['lowercase']
      error_message.push "Should include 1 lowercase letter! " unless password =~ /^(?=.*?[a-z]).{1,}$/
    elsif pass_settings['numbers']
      error_message.push "Should include 1 number! " unless password =~ /^(?=.*?[0-9]).{1,}$/
    elsif pass_settings['special_chars']
      error_message.push "Should include 1 special character! " unless password =~ /^(?=.*?[#?!@$%^&*-]).{1,}$/
    end
    return if password.blank? || error_message.empty?
    errors.add(:password, error_message.join(', '))
  rescue
    errors.add(:password, "Password validations failed!")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.get_users_with_fullname
    User.where.not(last_name: ['', nil]).or(User.where.not(first_name: [nil, ''])).map{|u| ["#{u.first_name} #{u.last_name}", u.id]}
  end

  def checklist_json
    {
      id: self.id,
      full_name: self.full_name
    }
  end

  def as_json(options=nil)
    json = super(options)
    json.merge(
      full_name: full_name,
      organization: organization&.title  || ""
    ).as_json
  end

  # def to_json(options={})
  #   json = super(options)
  #   all_organisations = options[:all_organisations]
  #   o = all_organisations.detect{|oo| oo.id == self.organisation_id}
  #   json.merge(
  #     full_name: full_name,
  #     organization: o&.title  || ""
  #   )
  # end

  def get_preferences
    # if preferences.project_group_id.present?
    #   preferences.project_group = FacilityGroup.find(preferences.project_group_id)
    # end
    # if preferences.project_id.present?
    #   preferences.project = FacilityProject.where(facility_id: preferences.project_id).first
    # end
    p = self.settings(:preferences)
    if p.new_record?
      p.value =  PREFERENCES_HASH
      p.save
    end
    p
  end

  def active_for_authentication?
    super and self.active?
  end

  def inactive_message
    "You are not allowed to log in!"
  end

  def abilities
    Ability.new(self).permissions
  end

  def admin?(params = {})
    if superadmin? || (privilege.admin && privilege.admin.include?("R") )
      return true
    elsif params[:project_id]
      return is_program_admin?(params[:project_id])
    else
      return false
    end
  end

  def is_program_admin?(program_id)
    
    program = self.projects.where(id: program_id).active.first
    if program
      return self.role_users.includes(:role_privileges).where("role_privileges.role_type" => RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES, "role_users.project_id" => program_id).count > 0
    else
      return false
    end
  end

  def has_program_admin_role?
    self.roles.distinct.where(id: Role.program_admin_user_role.id).any?
  end

  def programs_with_program_admin_role
    project_ids = self.role_users.where(role_id: Role.program_admin_user_role.id).pluck(:project_id).uniq
    self.projects.where(id: project_ids)
  end

  def initialize(*args)
    privilege ||= Privilege.new
    super
  end

  def admin_read?
    superadmin? || privilege.admin.include?("R")
  end

  def admin_write?
    superadmin? || (admin_read? && privilege.admin.include?("W"))
  end

  def admin_delete?
    superadmin? || (admin_read? && privilege.admin.include?("D"))
  end

  def admin_privilege
    superadmin? ? "RWD" : privilege.admin
  end

  def download_links?
    admin_write? ? [:csv, :json] : false
  end

  def set_color
    self.color = "##{SecureRandom.hex(3)}"
  end

  def project_names
    projects.active.pluck :name
  end

  # NOTE: this function is used for top level navigation
  # check javascript/packs/dashboard.js
  def privilege_hash
    p = self.privilege
    h = {
      map_view: p.map_view || "",
      gantt_view: p.gantt_view || "",
      members: p.members || "",
      settings_view: p.settings_view || "", 
      sheets_view: p.sheets_view || "",
      kanban_view: p.kanban_view || "",
      calendar_view: p.calendar_view || "",
      contract_data: p.contract_data || ""
      #NOTE: hard coding because lesson will go under project level. 
      # Once front end is working with project, do remove this permission.
      # This is used in topLevelNavigation for now 
    }
  end

  # NOTE: We are not using this method.
  #This will build has like this
  # {<project_id> : { <contract_id>: { <all_perissions> } }
  def contract_privileges_hash

    # return {}

    user = self
    cp = user.contract_privileges
    
    cids = user.contract_ids #fp.pluck(:project_id)    
    
    fph = Hash.new{|h, (k,v)| h[k] = {authorized_contract_ids: []} }
    fph2 = Hash.new{|h, (k,v)| h[k] = [] }

    cp.each do |c|
      contract_ids = c.contract_ids
      f_permissions = c.attributes.slice("overview", "tasks", "notes", "issues", "risks", "lessons").clone.transform_values{|v| v.delete(""); v }
      # f_permissions = c.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "facility_project_ids", "facility_project_id", "facility_id").clone.transform_values{|v| v.delete(""); v }
      f_permissions = f_permissions.transform_values{|v| v.delete(""); v}

      contract_ids.each do |fid|
        fph2[c.project_id.to_s] << fid.to_s 
        fph[c.project_id.to_s][fid] = f_permissions.merge!({"contract_id" => fid})
        
        if f_permissions["overview"].include?("R") || f_permissions["tasks"].include?("R") || f_permissions["notes"].include?("R") || f_permissions["issues"].include?("R") || f_permissions["risks"].include?("R") || f_permissions["lessons"].include?("R")
          fph[c.project_id.to_s][:authorized_contract_ids] << fid
        end
      end
    end

    pp_hash = user.project_privileges_hash

    project_contract_hash = Contract.where("id in (?) and project_id is not null", cids).group_by{|p| p.project_id.to_s}.transform_values{|fp| fp.map(&:id).map(&:to_s).compact.uniq }

    project_contract_hash.each do |pid, fids|
      fids2 = fids - ( fph2[pid] || [])
      # p_privilege = (pp_hash[pid] || {}).except("map_view", "gantt_view", "watch_view", "documents", "members", "sheets_view", "settings_view", "kanban_view", "calendar_view", "portfolio_view")

      p_privilege = (pp_hash[pid] || {}).slice("cn_overview", "cn_tasks", "cn_notes", "cn_issues", "cn_risks", "cn_lessons")
      fids2.each do |ff|
        fph[pid][ff] = {overview: p_privilege["cn_overview"] , tasks: p_privilege["cn_tasks"], issues: p_privilege["cn_issues"] , risks: p_privilege["cn_risks"],lessons: p_privilege["cn_lessons"], notes: p_privilege["cn_notes"], contract_id: ff }
        # fph[pid][ff] = p_privilege.clone.merge!({"contract_id" => ff})
        if p_privilege.present? && (p_privilege["cn_overview"].include?("R") || p_privilege["cn_tasks"].include?("R") || p_privilege["cn_notes"].include?("R") || p_privilege["cn_issues"].include?("R") || p_privilege["cn_risks"].include?("R") || p_privilege["cn_lessons"].include?("R") )
          fph[pid][:authorized_contract_ids] << ff
        end
      end       
    end
    fph.with_indifferent_access
  end

  #NOTE: This method is used in convert_privilege_roles rake task.
  def project_privileges_hash

    # return {}

    user = self     
    pv = user.project_privileges
    ph = {}
    project_ids_with_privileges = []
    pv.each do |p|
      pids = p.project_ids.map(&:to_s)
      project_ids_with_privileges = project_ids_with_privileges + pids
      module_permissions = p.attributes.clone.except("id", "created_at", "updated_at", "user_id", "project_id", "project_ids")
      module_permissions.transform_values{|v| v.delete(""); v}

      pids.each do |pid|
        ph[pid.to_s] = module_permissions
      end
    end

    project_ids_with_privileges = project_ids_with_privileges.compact.uniq
    user_project_ids = user.project_ids.map(&:to_s)
    remaining_project_ids = user_project_ids - project_ids_with_privileges
    
    # if remaining_project_ids.any?
    #   user_privilege_attributes = (user.privilege || Privilege.new(user_id: user.id)).attributes.clone
    #   user_privilege_attributes = user_privilege_attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "facility_manager_view")
    #   user_privilege_attributes = user_privilege_attributes.reject{|k,v| v.nil? }.transform_values{|v| v.delete(""); v.chars}

    #   remaining_project_ids.each do |pid|
    #     ph[pid.to_s] = user_privilege_attributes
    #   end
    # end

    ph.with_indifferent_access

  end

  #NOTE: This method is used in convert_privilege_roles rake task.
  #This will build has like this
  # {<project_id> : { <facility_id>: { <all_perissions> } }
  def facility_privileges_hash

    # return {}

    user = self
    fp = user.facility_privileges
    
    pids = user.project_ids #fp.pluck(:project_id)    
    
    fph = Hash.new{|h, (k,v)| h[k] = {} }
    fph2 = Hash.new{|h, (k,v)| h[k] = [] }

    fp.each do |f|
      facility_project_ids = f.facility_project_ids
      f_permissions = f.attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "facility_project_ids", "facility_project_id", "facility_id").clone.transform_values{|v| v.delete(""); v }
      f_permissions = f_permissions.transform_values{|v| v.delete(""); v}

      facility_project_ids.each do |fid|
        fph2[f.project_id.to_s] << fid.to_s 
        fph[f.project_id.to_s][fid] = f_permissions.merge!({"facility_id" => fid})
      end
    end

    pp_hash = user.project_privileges_hash

    facility_project_hash = FacilityProject.where(project_id: pids).group_by{|p| p.project_id.to_s}.transform_values{|fp| fp.flatten.map{|f| f.facility_id.to_s }.compact.uniq }

    facility_project_hash.each do |pid, fids|
      fids2 = fids - ( fph2[pid] || [])
      p_privilege = (pp_hash[pid] || {}).except("map_view", "gantt_view", "watch_view", "documents", "members", "sheets_view", "settings_view", "kanban_view", "calendar_view", "portfolio_view")
      fids2.each do |ff|
        fph[pid][ff] = p_privilege.clone.merge!({"facility_id" => ff})
      end       
    end
    fph.with_indifferent_access
  end

  #This will build has like this
  # {<project_id> : { <facility_id>: { <all_perissions> } }
  def program_settings_privileges_hash

    return {}

    user = self
    pv = user.project_privileges
    ph = {}
    project_ids_with_privileges = []
    pv.each do |p|
      pids = p.project_ids.map(&:to_s)
      project_ids_with_privileges = project_ids_with_privileges + pids
      module_permissions = p.attributes.clone.slice("admin_groups", "admin_contracts", "admin_facilities")
      module_permissions.transform_values{|v| v.delete(""); v}

      pids.each do |pid|
        ph[pid.to_s] = module_permissions
      end
    end

    project_ids_with_privileges = project_ids_with_privileges.compact.uniq
    user_project_ids = user.project_ids.map(&:to_s)
    remaining_project_ids = user_project_ids - project_ids_with_privileges

    ph.with_indifferent_access
  end

  # This will generate array of hash like this
  # e.g [{1441=>{:project_id=>9, :facility_id=>1438, "project_analytics"=>["R", "W"], "project_notes"=>["R", "W"]}}]
  # {<facility_project_id>=>{<role types>=><privileges array>}} e.g. {1441=>{"project_notes"=>["R", "W"]}}
  def facility_privileges_hash_by_role(program_ids: [])
    user = self
    program_ids = user.project_ids if !program_ids.any?
    project_hash = {}
    role_users = user.role_users.where.not(facility_project_id: nil)
    project_role_privileges = RolePrivilege.where(role_type: RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES, role_id: role_users.pluck(:role_id).uniq ).group_by(&:role_id)
    all_facility_projects = FacilityProject.where(id: role_users.map(&:facility_project_id).compact.uniq ) 
    facility_project_hash = all_facility_projects.group_by{|fp| fp.id}.transform_values{|values| values.map{|v| [v.project_id, v.facility_id] }.flatten.compact }

    role_users.each do |role_user|
      
      fp_id = role_user.facility_project_id
      if  fp_id && (role_privilegs = project_role_privileges[role_user.role_id])
        h2 = {}
        role_privilegs.each do |rp|          
          h2[rp.role_type] = rp.privilege&.chars
        end
        project_hash[fp_id] = h2
      end
    end

    # If user has program admin role and do not have project privilege role
    # then we will provide full privilege for project associated with that program
    # but if user has defined project privilege role and assigned to user then 
    # it will overwrite those privileges
    # program_ids.each do |pid|
    #   if has_program_setting_role?(pid)
    #     pph = project_privileges_hash_by_role(program_ids: [pid])
    #     all_facility_project_ids = FacilityProject.where(project_id: pid).pluck(:id)
    #     all_facility_project_ids.each do |fp_id2|
    #       if !project_hash[fp_id2]
    #         h2 = {}
    #         RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.each do |role_type|          
    #           h2[role_type] = ["R", "W", "D"]
    #         end
    #         project_hash[fp_id2] = h2
    #       end
    #     end
    #   end
    # end

    project_hash.with_indifferent_access
  end
  
  # This will generate array of hash like this
  # {<project_contract id>=>{<role types>=><privileges array>}} e.g. {1441=>{"contract_notes"=>["R", "W"]}}
  def contract_privileges_hash_by_role(program_ids: [])
    user = self
    program_ids = user.project_ids if !program_ids.any?
    contarct_hash = {}
    # role_users = user.role_users.where.not(project_contract_id: nil)
    role_users = user.role_users.joins(:role_privileges).where(project_id: program_ids, role_privileges: {role_type: RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES} ).distinct
    contract_role_privileges = RolePrivilege.where(role_type: RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES, role_id: role_users.pluck(:role_id) ).group_by(&:role_id)
    contracts_group_by_project = ProjectContract.where(project_id: program_ids).group_by(&:project_id)

    role_users.each do |role_user|
      role_privilegs = contract_role_privileges[role_user.role_id]
      if role_user.project_contract_id && role_privilegs
        h2 = {}
        role_privilegs.each do |rp|          
          h2[rp.role_type] = rp.privilege&.chars
        end
        contarct_hash[role_user.project_contract_id] = h2
      # elsif role_user.project_id.present? && role_user.project_contract_id.nil?
      #   contracts = contracts_group_by_project[role_user.project_id] || []
      #   contracts.each do |contract|
      #     next if contarct_hash[contract.id] || !role_privilegs
      #     h2 = {}
      #     role_privilegs.each do |rp|          
      #       h2[rp.role_type] = rp.privilege&.chars
      #     end
      #     contarct_hash[contract.id] = h2
      #   end
      end
      
    end
    contarct_hash.with_indifferent_access
  end

  def project_privileges_hash_by_role(program_ids: [])    
    user = self
    program_ids = user.project_ids if !program_ids.any?
    role_ids = user.roles.joins(:role_users).where( "role_users.project_id" => program_ids).distinct.pluck(:id)
    role_privileges = RolePrivilege.where(role_id: role_ids,role_type: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES)
    role_privileges.as_json(only: [:name, :privilege, :role_type])
  end

  def has_program_setting_role?(program_id, action, role_type)
    user = self
    role_ids = user.roles.joins(:role_users).where( "role_users.project_id" => program_id).distinct.pluck(:id)
    role_privileges = RolePrivilege.where(role_id: role_ids,role_type: role_type)
    # role_privileges.group_by(&:role_type).transform_values{|v| v.first.privileges }
    # role_privileges.as_json(only: [:name, :privilege, :role_type])
    has_access = false
    role_privileges.each do |rp|
      has_access = (rp.privilege.chars.include?(action))
      break if has_access
    end
    has_access
  end

  def authorized_facility_project_ids(project_ids: [])
    fids = self.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.facility_project_id is not null").select("distinct(facility_project_id)").map(&:facility_project_id)
    if project_ids.any?
      fids = FacilityProject.where(project_id: project_ids, id: fids).pluck(:id)
    end
    fids
  end

  def program_settings_privileges_hash_by_role(program_ids: [])
    user = self
    program_ids = user.project_ids if !program_ids.any?
    role_ids = user.roles.joins(:role_users).where( "role_users.project_id" => program_ids).distinct.pluck(:id)
    role_privileges = RolePrivilege.where(role_id: role_ids,role_type: RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES)
    # role_privileges.group_by(&:role_type).transform_values{|v| v.first.privileges }
    # role_privileges.as_json(only: [:name, :privilege, :role_type])
    hash = {}
    role_privileges.each do |rp|
      hash[rp.role_type] = rp.privilege.chars
    end
    hash.with_indifferent_access
  end 

  def authorized_contract_ids(project_ids: []) 
    user = self
    # role_types = RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES + RolePrivilege::PROGRAM_SETTINGS_ROLE_TYPES
    # project_contract_ids = user.role_users.joins(:role_privileges).where("role_privileges.role_type in (?)", role_types).distinct.pluck(:project_contract_id).compact
    # if project_ids.any?
    #   project_contract_ids = ProjectContract.where(project_id: project_ids, id: project_contract_ids).pluck(:id)
    # end
    # project_contract_ids

    fids = user.role_users.joins(:role_privileges).where("role_privileges.privilege REGEXP '^[RWD]' and role_users.project_contract_id is not null").select("distinct(project_contract_id)").map(&:project_contract_id)
    if project_ids.any?
      fids = ProjectContract.where(project_id: project_ids, id: fids).pluck(:id)
    end
    fids

  end

  def authorized_contracts(project_ids: [])
    ProjectContract.where(id: authorized_contract_ids(project_ids: project_ids) )
  end

  # def has_contract_permission?(action: "read", resource: , program: nil, contract: nil, project_privileges_hash: {}, contract_privileges_hash: {} )
  #   begin
  #     program_id = program.is_a?(Project) ? program.id.to_s : program.to_s
  #     contract_id = contract.is_a?(Contract) ? contract.id.to_s : contract.to_s
  #     action_code_hash = {"read" => "R", "write" => "W", "delete" => "D"}
  #     pph = project_privileges_hash.present? ? project_privileges_hash : self.project_privileges_hash
  #     result = false
  #     short_action_code = action_code_hash[action]
  #     if pph[program_id]
  #       fph = contract_privileges_hash.present? ? contract_privileges_hash : self.contract_privileges_hash
  #       if fph[program_id][contract_id]
  #         result = fph[program_id][contract_id][resource].include?(short_action_code)
  #       else
  #         result = pph[program_id][resource].include?(short_action_code)
  #       end
  #     end
  #   rescue Exception => e
  #     puts "Exception in  User#has_permission? #{e.message}"
  #     result = false
  #   end
  #   return result
  # end

  def has_permission?(action: "read", resource: , program: nil, project: nil, project_privileges_hash: {}, facility_privileges_hash: {} )

    return has_permission_by_role?({action: "read", resource: resource, program: program, project: project})

    # begin
    #   program_id = program.is_a?(Project) ? program.id.to_s : program.to_s
    #   project_id = project.is_a?(Facility) ? project.id.to_s : project.to_s
    #   action_code_hash = {"read" => "R", "write" => "W", "delete" => "D"}
    #   pph = project_privileges_hash.present? ? project_privileges_hash : self.project_privileges_hash
    #   result = false
    #   short_action_code = action_code_hash[action]
    #   if pph[program_id]
    #     fph = facility_privileges_hash.present? ? facility_privileges_hash : self.facility_privileges_hash
    #     if fph[program_id][project_id]
    #       result = fph[program_id][project_id][resource].include?(short_action_code)
    #     else
    #       result = pph[program_id][resource].include?(short_action_code)
    #     end        
    #   end
    # rescue Exception => e
    #   puts "Exception in  User#has_permission? #{e.message}"
    #   result = false
    # end
    # return result
  end

  def has_permission_by_role?(args)

    program = args[:program]
    project = args[:project]
    action = args[:action]
    project_contract = args[:project_contract]
    resource = args[:resource]

    begin
      user = self
      action_code_hash = {"read" => "R", "write" => "W", "delete" => "D"}

      if project_contract
        project_contract = project_contract.is_a?(ProjectContract) ? project_contract : ProjectContract.find( project_contract.to_s)

        program_id = project_contract.project_id.to_s

        role_ids = user.role_users.select{|ru| ru.project_id == program_id.to_i &&  ru.project_contract_id == project_contract.id }.map(&:role_id).compact.uniq
        role_type = RolePrivilege::CONTRACT_PRIVILEGS_ROLE_TYPES.detect{|rt| rt.include?(resource)}
      else
        program_id = program.is_a?(Project) ? program.id.to_s : program.to_s
        project_id = project.is_a?(Facility) ? project.id.to_s : project.to_s
        facility_project_id = user.facility_projects.detect{|fp| fp.project_id == program_id.to_i && fp.facility_id == project_id.to_i}.id
        
        role_ids = user.role_users.select{|ru| ru.facility_project_id == facility_project_id}.map(&:role_id).compact.uniq
        role_type = RolePrivilege::PROJECT_PRIVILEGS_ROLE_TYPES.detect{|rt| rt.include?(resource)}
      end      
      role_privileges = user.role_privileges.select{|rp| role_ids.include?(rp.role_id) && rp.role_type == role_type}.map(&:privilege).compact.flatten.join.chars.uniq

      result = false
      short_action_code = action_code_hash[action]
      if short_action_code == "R"
        result = role_privileges.include?("R") || role_privileges.include?("W") || role_privileges.include?("D")
      else
        result = role_privileges.include?(short_action_code)
      end

    rescue Exception => e
      puts "Exception in  User#has_permission_by_role? #{e.message}"
      result = false
    end
    return result
  end

  def has_contract_permission?(action: "read", resource: , project_contract: nil, project_privileges_hash: {},contract_privileges_hash: {} )

    return has_permission_by_role?({action: "read", resource: resource , project_contract: project_contract})

    # begin
    #   contract = contract.is_a?(Contract) ? contract : Contract.find(contract.to_s)
    #   contract_id = contract.id.to_s
    #   program_id = contract.project_id.to_s
      
    #   action_code_hash = {"read" => "R", "write" => "W", "delete" => "D"}
    #   pph = project_privileges_hash.present? ? project_privileges_hash : self.project_privileges_hash
    #   result = false
    #   short_action_code = action_code_hash[action]

    #   if pph[program_id]
    #     fph = contract_privileges_hash.present? ? contract_privileges_hash : self.contract_privileges_hash[program_id]
    #     if fph[contract_id]
    #       result = fph[contract_id][resource].include?(short_action_code)
    #     else
    #       result = pph[resource].include?(short_action_code)
    #     end       
    #   end
    # rescue Exception => e
    #   puts "Exception in  User#has_contract_permission? #{e.message}"
    #   result = false
    # end
    # return result
  end

  def allowed?(view)
    # privilege.send(view)&.include?("R") || superadmin? || privilege.admin.include?("R")
    # return true if (superadmin? || privilege.admin.include?("R"))
    if allowed_navigation_tabs.any?
      allowed_navigation_tabs.include?(view)
    else
      view == "sheets_view"
    end
  end

end
