if defined?(DatabaseCleaner)
  # cleaning the database using database_cleaner
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
else
  logger.warn "add database_cleaner or update cypress/app_commands/clean.rb"
  Issue.delete_all if defined?(Issue)
  Task.delete_all if defined?(Task)
  FacilityProject.delete_all if defined?(FacilityProject)
  Facility.delete_all if defined?(Facility)
  FacilityGroup.delete_all if defined?(FacilityGroup)
  IssueSeverity.delete_all if defined?(IssueSeverity)
  IssueType.delete_all if defined?(IssueType)
  IssueStage.delete_all if defined?(IssueStage)
  TaskStage.delete_all if defined?(TaskStage)
  TaskType.delete_all if defined?(TaskType)
  Status.delete_all if defined?(Status)
  ProjectUser.delete_all if defined?(ProjectUser)
  Project.delete_all if defined?(Project)
  ProjectType.delete_all if defined?(ProjectType)
  Organization.delete_all if defined?(Organization)
  Setting.delete_all if defined?(Setting)
  Privilege.delete_all if defined?(Privilege)
  User.delete_all if defined?(User)
end

Rails.logger.info "APPCLEANED" # used by log_fail.rb
