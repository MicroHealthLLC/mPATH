class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  # after_create :provide_program_privileges
  after_destroy :remove_program_privileges
  after_destroy :remove_program_related_roles
  validates :user_id, uniqueness: { scope: [ :project_id ], message: "Can't add same user multiple times in same project."  }, on: :create

  def remove_program_related_roles
    self.user.role_users.where(project_id: self.project_id).destroy_all
  end

  def remove_program_privileges
    self.user.remove_all_privileges(self.project_id)
  end

  def provide_program_privileges
    self.user.provide_program_privileges
  end
end
