class Project < ApplicationRecord
  has_many :tasks, through: :facilities
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :facility_projects, dependent: :destroy
  has_many :facilities, through: :facility_projects
  has_many :comments, as: :resource, dependent: :destroy, class_name: 'ActiveAdmin::Comment'
  accepts_nested_attributes_for :comments, reject_if: :reject_comment

  belongs_to :project_type

  enum status: [:inactive, :active]

  before_create :set_uuid
  after_commit :grant_access_to_admins

  def as_json(options=nil)
    json = super(options)
    json.merge(
      project_type: self.project_type.try(:name),
      facility_count: self.facilities.count
    ).as_json
  end

  def reject_comment(comment)
    return comment['body'].blank?
  end

  private
    def set_uuid
      self.uuid = SecureRandom.uuid
    end

    def grant_access_to_admins
      self.users << User.admin.where.not(id: self.users.ids)
    end
end
