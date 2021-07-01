class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :facilities
  has_many :risks
  has_one :privilege, dependent: :destroy
  belongs_to :organization, optional: true
  has_many :query_filters, dependent: :destroy
  has_many :facility_privileges, dependent: :destroy
  has_many :project_privileges, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validate :password_complexity
  before_commit :set_color, on: :create

  enum role: [:client, :superadmin].freeze
  enum status: [:inactive, :active].freeze

  scope :admin, -> {joins(:privilege).where("privileges.admin LIKE ? OR role = ?", "%R%", 1).distinct}

  accepts_nested_attributes_for :privilege, reject_if: :all_blank
  accepts_nested_attributes_for :facility_privileges, reject_if: proc { |attributes| attributes['facility_project_ids'].blank? }, allow_destroy: true
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
    nagivation_tabs = ["member_list", "map_view", "gantt_view", "sheets_view", "kanban_view", "calendar_view"] - ["calendar_view", "gantt_view"]
    self.privilege.attributes.select{|k,v| v.is_a?(String) && v.include?(right)}.keys & nagivation_tabs
  end

  def build_navigation_tabs_for_profile
    n = []
    allowed_navigation_tabs.each do |t|
      name = "map" if t == "map_view"
      name = "kanban" if t == "kanban_view"
      name = "sheet" if t == "sheets_view"
      name = "member_list" if t == "member_list"
      
      #NOTE: Once front end routes are working, uncomment it.
      #name = "gantt_chart" if t == "gantt_view"      

      # name = "calendar" if t == "calendar_view"

      n << {id: name.downcase, name: name.humanize, value: name.downcase}
    end
    n
    #n << {id: 'member_list', name: 'Team', value: 'member_list'}
  end

  def allowed_sub_navigation_tabs(right = 'R')
    sub_nagivation_tabs = ["tasks", "issues", "notes", "risks", "overview"]
    self.privilege.attributes.select{|k,v| v.is_a?(String) && v.include?(right)}.keys & sub_nagivation_tabs
  end

  def build_sub_navigation_tabs_for_profile
    allowed_sub_navigation_tabs.map{|s| {id: s.downcase, name: s.humanize, value: s.downcase} }
  end

  def preference_url
    p = self.get_preferences
    top_navigations = allowed_navigation_tabs
    sub_navigations = allowed_sub_navigation_tabs
    url = "/"
    if p.program_id.present?

      url = "/programs/#{p.program_id}/sheet" # map must be

      if p.navigation_menu.present?

        navigtaion_present = false
        if top_navigations.include?(p.navigation_menu)
          url = "/programs/#{p.program_id}/#{p.navigation_menu}"
          navigtaion_present = true
        elsif top_navigations.size > 0
          url = "/programs/#{p.program_id}/#{top_navigations.first}"
          navigtaion_present = true
        else
          url = ""
        end
        
        if navigtaion_present && p.project_id.present?              

          if p.sub_navigation_menu.present?

            sub_navigation_present = false
            if sub_navigations.include?(p.sub_navigation_menu)
              url = "#{url}/projects/#{p.project_id}/#{p.sub_navigation_menu}"
              sub_navigation_present = true
            elsif sub_navigations.size > 0
              url = "#{url}/projects/#{p.project_id}/#{sub_navigations.first}"
              sub_navigation_present = true
            end

            # if p.sub_navigation_menu == "overview"
            #   url = "/programs/#{p.program_id}/#{p.navigation_menu}/projects/#{p.project_id}/"
            # else
            #   url = "/programs/#{p.program_id}/#{p.navigation_menu}/projects/#{p.project_id}/#{p.sub_navigation_menu}"
            # end
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
    pass_settings = JSON.parse(Setting['PASSWORDS_KEY'])
    error_message = []
    if pass_settings['range'].to_i != password&.size
      error_message.push "Length should be #{pass_settings['range']} characters"
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

  def admin?
    superadmin? || privilege.admin.include?("R")
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
      map_view: p.map_view,
      gantt_view: p.gantt_view,
      members: p.members,
      sheets_view: p.sheets_view,
      kanban_view: p.kanban_view,
      calendar_view: p.calendar_view,
      #NOTE: hard coding because lesson will go under project level. 
      # Once front end is working with project, do remove this permission.
      # This is used in topLevelNavigation for now 
      lessons: p.lessons
    }
  end

  def project_privileges_hash
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
    
    if remaining_project_ids.any?
      user_privilege_attributes = (user.privilege || Privilege.new(user_id: user.id)).attributes.clone
      user_privilege_attributes = user_privilege_attributes.except("id", "created_at", "updated_at", "user_id", "project_id", "group_number", "facility_manager_view")
      user_privilege_attributes = user_privilege_attributes.transform_values{|v| v.delete(""); v.chars}

      remaining_project_ids.each do |pid|
        ph[pid.to_s] = user_privilege_attributes
      end
    end

    ph
  end

  #This will build has like this
  # {<project_id> : { <facility_id>: { <all_perissions> } }
  def facility_privileges_hash
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

    facility_project_hash = FacilityProject.includes(:facility, :project).where(project_id: pids).group_by{|p| p.project_id.to_s}.transform_values{|fp| fp.flatten.map{|f| f.facility_id.to_s }.compact.uniq }

    facility_project_hash.each do |pid, fids|
      fids2 = fids - ( fph2[pid] || [])
      p_privilege = pp_hash[pid]
      fids2.each do |ff|
        fph[pid][ff] = p_privilege.clone.merge!({"facility_id" => ff})
      end       
    end
    fph
  end

  def has_permission?(action: "read", resource: , program: nil, project: nil, project_privileges_hash: {}, facility_privileges_hash: {} )
    begin
      program_id = program.is_a?(Project) ? program.id.to_s : program.to_s
      project_id = project.is_a?(Facility) ? project.id.to_s : project.to_s
      action_code_hash = {"read" => "R", "write" => "W", "delete" => "D"}
      pph = project_privileges_hash.present? ? project_privileges_hash : self.project_privileges_hash
      result = false
      short_action_code = action_code_hash[action]
      if pph[program_id]
        fph = facility_privileges_hash.present? ? facility_privileges_hash : self.facility_privileges_hash
        if fph[program_id][project_id]
          result = fph[program_id][project_id][resource].include?(short_action_code)
        else
          result = pph[program_id][resource].include?(short_action_code)
        end        
      end
    rescue Exception => e
      puts "Exception in  User#has_permission? #{e.message}"
      result = false
    end
    return result
  end

  def allowed?(view)
    privilege.send(view)&.include?("R") || superadmin? || privilege.admin.include?("R")
  end

end
