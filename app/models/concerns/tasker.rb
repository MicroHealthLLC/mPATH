require 'uri'

module Tasker
  extend ActiveSupport::Concern

  included do |base|
    default_scope {order(due_date: :asc)}

    scope :complete, -> {where("progress = ?", 100)}
    scope :incomplete, -> {where("progress < ?", 100)}

    belongs_to :facility_project, optional: true #since now we can create task under contract
    belongs_to :contract, optional: true
    # New contract functionality
    belongs_to :project_contract, optional: true
    has_one :contract_project_data, through: :project_contract

    belongs_to :project_contract_vehicle, optional: true
    has_one :contract_vehicle, through: :project_contract_vehicle

    has_one :facility, through: :facility_project
    has_one :project, through: :facility_project
    has_one :facility_group, through: :facility_project
    has_one :contract_project, class_name: "Project", through: :project_contract
    has_one :contract_vehicle_project, class_name: "Project", through: :project_contract_vehicle
    has_one :contract_facility_group, class_name: "FacilityGroup", through: :project_contract

    has_many :checklists, as: :listable, dependent: :destroy

    has_many :related_tasks, as: :relatable, dependent: :destroy
    has_many :related_issues, as: :relatable, dependent: :destroy
    has_many :related_risks, as: :relatable, dependent: :destroy
    has_many :sub_tasks, through: :related_tasks, class_name: "Task"
    has_many :sub_issues, through: :related_issues, class_name: "Issue"
    has_many :sub_risks, through: :related_risks, class_name: "Risk"

    accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :facility_project, reject_if: :all_blank

    validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

    before_save :check_watched, if: :watched_changed?
    after_save :remove_on_watch
    after_save :handle_related_taskers
    after_validation :setup_facility_project

    scope :inactive_project, -> { where.not(facility_project: { projects: { status: 0 } }) }
    scope :inactive_facility, -> { includes(facility_project: [:facility]).where.not(facility_project: { facilities: { status: 0 } }) }

    base.const_set :URL_FILENAME_LENGTH, 252

    def valid_url?(url)
      uri = URI.parse(url)
      (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) ) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
    
    def is_contract_resource?
      self.project_contract_id.present?
    end

    def setup_facility_project
      return unless facility_project.present?
      return if self.is_contract_resource?
      if facility_project.facility_id_changed? || facility_project.project_id_changed?
        self.facility_project = FacilityProject.find_or_initialize_by(project: self.project, facility: self.facility)
      end
    end

    def check_watched
      self.watched_at = DateTime.now
    end

    def update_closed     
      if self.ongoing && self.due_date.present? && !self.draft && !self.on_hold
        self.closed_date = self.due_date
      end
    end

    # def project
    #   facility_project.try(:project)
    # end

    # def facility
    #   facility_project.try(:facility)
    # end

    def remove_on_watch
      if self.progress == 100 && self.watched == true
        self.update(watched: false)
      end
    end

    def update_owner_record
      if self.previous_changes.keys.include?("progress")
        _owner = nil
        if facility_project.present?
          _owner = facility_project
        elsif project_contract_id.present?
          _owner = project_contract
        elsif project_contract_vehicle_id.present?
          _owner = project_contract_vehicle
        end
  
        return if !_owner
  
        p = _owner.project
        _owner.update_progress
        p.update_progress
        FacilityGroup.where(project_id: p.id).map(&:update_progress)
      end
    end
    
    def handle_related_taskers
      subclass = "sub_#{self.class.name.downcase.pluralize}"
      sub_tasks.each{|t| t.send(subclass) << self unless t.send(subclass).include? self}
      sub_issues.each{|i| i.send(subclass) << self unless i.send(subclass).include? self}
      sub_risks.each{|r| r.send(subclass) << self unless r.send(subclass).include? self}
      RelatedTask.where(task_id: self.id, relatable_type: self.class.name).where.not(relatable_id: sub_task_ids).destroy_all
      RelatedIssue.where(issue_id: self.id, relatable_type: self.class.name).where.not(relatable_id: sub_issue_ids).destroy_all
      RelatedRisk.where(risk_id: self.id, relatable_type: self.class.name).where.not(relatable_id: sub_risk_ids).destroy_all
    end
  end
end
