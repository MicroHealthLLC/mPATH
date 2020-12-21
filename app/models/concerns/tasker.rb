module Tasker
  extend ActiveSupport::Concern

  included do
    scope :complete, -> {where("progress = ?", 100)}
    scope :incomplete, -> {where("progress < ?", 100)}

    belongs_to :facility_project
    has_many :checklists, as: :listable, dependent: :destroy

    has_many :related_tasks, as: :relatable, dependent: :destroy
    has_many :related_issues, as: :relatable, dependent: :destroy
    has_many :related_issues, as: :relatable, dependent: :destroy
    has_many :sub_tasks, through: :related_tasks
    has_many :sub_issues, through: :related_issues
    has_many :sub_risks, through: :related_risks

    accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :facility_project, reject_if: :all_blank

    validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

    before_save :check_watched, if: :watched_changed?
    after_validation :setup_facility_project

    def setup_facility_project
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
  end
end
