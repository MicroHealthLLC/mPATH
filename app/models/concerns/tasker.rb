require 'uri'

module Tasker
  extend ActiveSupport::Concern

  included do
    default_scope {order(due_date: :asc)}

    scope :complete, -> {where("progress = ?", 100)}
    scope :incomplete, -> {where("progress < ?", 100)}

    belongs_to :facility_project
    has_many :checklists, as: :listable, dependent: :destroy

    has_many :related_tasks, as: :relatable, dependent: :destroy
    has_many :related_issues, as: :relatable, dependent: :destroy
    has_many :related_risks, as: :relatable, dependent: :destroy
    has_many :sub_tasks, through: :related_tasks
    has_many :sub_issues, through: :related_issues
    has_many :sub_risks, through: :related_risks

    accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :facility_project, reject_if: :all_blank

    validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

    before_save :check_watched, if: :watched_changed?
    after_save :remove_on_watch
    after_save :handle_related_taskers
    after_validation :setup_facility_project


    def valid_url?(url)
      uri = URI.parse(url)
      (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) ) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end

    def setup_facility_project
      return unless facility_project.present?
      if facility_project.facility_id_changed? || facility_project.project_id_changed?
        self.facility_project = FacilityProject.find_or_initialize_by(project: self.project, facility: self.facility)
      end
    end

    def check_watched
      self.watched_at = DateTime.now
    end

    def project
      facility_project.try(:project)
    end

    def facility
      facility_project.try(:facility)
    end

    def remove_on_watch
      if self.progress == 100 && self.watched == true
        self.update_attributes(watched: false)
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
