class Project < ApplicationRecord
  has_many :facilities, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :project_users
  has_many :users, through: :project_users
  
  enum status: [:pending, :completed]
  enum project_type: [:project_type1, :project_type2]

  before_create :set_uuid

  # def as_json(options=nil)
  #   json = super(options)
  #   json.merge(
  #     progress: progress,
  #     tasks: self.tasks.as_json
  #   ).as_json
  # end

  def progress
    self.tasks.map(&:progress).sum/self.tasks.count rescue 0
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
