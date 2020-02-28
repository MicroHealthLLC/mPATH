class Project < ApplicationRecord
  has_many :facilities, dependent: :destroy
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  belongs_to :project_type
  belongs_to :status

  before_create :set_uuid
  after_commit :grant_access_to_admins

  def as_json(options=nil)
    json = super(options)
    json.merge(
      project_type: self.project_type.try(:name),
      status: self.status.try(:name)
    ).as_json
  end

  private

    def set_uuid
      self.uuid = SecureRandom.uuid
    end

    def grant_access_to_admins
      self.users << User.admin.where.not(id: self.users.ids)
    end
end
