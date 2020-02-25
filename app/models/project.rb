class Project < ApplicationRecord
  has_many :regions, dependent: :destroy
  has_many :states, through: :regions
  has_many :facilities, dependent: :destroy
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users


  enum status: [:pending, :completed]

  before_create :set_uuid

  def as_json(options=nil)
    json = super(options)
    json.merge(
      regions: self.regions.as_json
    ).as_json
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
