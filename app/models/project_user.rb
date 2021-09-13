class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  after_create :provide_program_privileges
  after_destroy :remove_program_privileges

  def remove_program_privileges
    self.user.remove_all_privileges(self.project_id)
  end

  def provide_program_privileges
    self.user.provide_program_privileges
  end
end
