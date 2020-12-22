class Risk < ApplicationRecord
  include Normalizer
  include Tasker

  belongs_to :user
  belongs_to :risk_milestone
  has_many_attached :risk_files, dependent: :destroy

  enum risk_approach: [:avoid, :mitigate, :transfer, :accept]

  validates_inclusion_of :probability, in: 1..5
  validates_inclusion_of :impact_level, in: 1..5
  validates_presence_of :risk_description, :start_date, :due_date

  before_validation :cast_constants_to_i

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

  private
  def cast_constants_to_i
    self.probability = self.probability.to_i
    self.impact_level = self.impact_level.to_i
    self.priority_level = self.probability * self.impact_level
  end
end
