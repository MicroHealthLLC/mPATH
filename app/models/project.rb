class Project < ApplicationRecord
  has_many :facilities, dependent: :destroy
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  belongs_to :project_type

  enum status: [:pending, :completed]

  before_create :set_uuid
  after_commit :grant_access_to_admins, on: :create

  private

    def set_uuid
      self.uuid = SecureRandom.uuid
    end

    def grant_access_to_admins
      self.users << User.admin.where.not(id: self.users.ids)
    end
end
