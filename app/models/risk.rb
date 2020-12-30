class Risk < ApplicationRecord
  include Normalizer
  include Tasker

  belongs_to :user
  belongs_to :task_type, optional: true
  has_many_attached :risk_files, dependent: :destroy

  enum risk_approach: [:avoid, :mitigate, :transfer, :accept]

  validates_inclusion_of :probability, in: 1..5
  validates_inclusion_of :impact_level, in: 1..5
  validates_presence_of :risk_description, :start_date, :due_date

  before_validation :cast_constants_to_i
  before_destroy :nuke_it!

  def files_as_json
    risk_files.map do |file|
      {
        id: file.id,
        name: file.blob.filename,
        uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end.as_json
  end

  def to_json
    attach_files = []
    rf = self.risk_files
    if rf.attached?
      attach_files = rf.map do |file|
        {
          id: file.id,
          name: file.blob.filename,
          uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end
    fp = self.facility_project
    sub_tasks = self.sub_tasks
    sub_issues = self.sub_issues
    sub_risks = self.sub_risks

    self.as_json.merge(
      class_name: self.class.name,
      attach_files: attach_files,
      is_overdue: progress < 100 && (due_date < Date.today),
      checklists: checklists.as_json,
      facility_id: fp.try(:facility_id),
      facility_name: fp.try(:facility)&.facility_name,
      project_id: fp.try(:project_id),
      sub_tasks: sub_tasks.as_json(only: [:text, :id]),
      sub_issues: sub_issues.as_json(only: [:title, :id]),
      sub_risks: sub_risks.as_json(only: [:risk_description, :id]),
      sub_task_ids: sub_tasks.map(&:id),
      sub_issue_ids: sub_issues.map(&:id),
      sub_risk_ids: sub_risks.map(&:id)
    ).as_json
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

  private
  def cast_constants_to_i
    self.probability = self.probability.to_i
    self.impact_level = self.impact_level.to_i
    self.priority_level = self.probability * self.impact_level
  end
end
