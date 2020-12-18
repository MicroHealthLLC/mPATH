class Risk < ApplicationRecord
  include Normalizer
  default_scope {order(due_date: :asc)}

  belongs_to :user
  belongs_to :facility_project
  belongs_to :risk_milestone
  has_many :checklists, as: :listable, dependent: :destroy
  has_many_attached :risk_files, dependent: :destroy

  has_many :related_tasks, as: :relatable, dependent: :destroy
  has_many :related_issues, as: :relatable, dependent: :destroy
  has_many :related_issues, as: :relatable, dependent: :destroy
  has_many :sub_tasks, through: :related_tasks
  has_many :sub_issues, through: :related_issues
  has_many :sub_risks, through: :related_risks

  enum risk_approach: [:avoid, :mitigate, :transfer, :accept]

  validates_inclusion_of :probability, in: 1..5
  validates_inclusion_of :impact_level, in: 1..5
  validates_presence_of :risk_description, :start_date, :due_date

  validates_numericality_of :progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  accepts_nested_attributes_for :checklists, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :facility_project, reject_if: :all_blank

  before_validation :cast_constants_to_i
  before_save :check_watched, if: :watched_changed?

  scope :complete, -> {where("progress = ?", 100)}
  scope :incomplete, -> {where("progress < ?", 100)}

  def files_as_json
    risk_files.map do |file|
      {
        id: file.id,
        name: file.blob.filename,
        uri: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end.as_json
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

  def project
    facility_project.try(:project)
  end

  def facility
    facility_project.try(:facility)
  end

  private
  def cast_constants_to_i
    self.probability = self.probability.to_i
    self.impact_level = self.impact_level.to_i
    self.priority_level = self.probability * self.impact_level
  end

  def check_watched
    self.watched_at = DateTime.now
  end
end
