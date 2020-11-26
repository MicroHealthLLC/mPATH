if defined?(DatabaseCleaner)
  # cleaning the database using database_cleaner
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
else
  logger.warn "add database_cleaner or update cypress/app_commands/clean.rb"
  Issue.destroy_all if defined?(Issue)
  Task.destroy_all if defined?(Task)
  FacilityProject.destroy_all if defined?(FacilityProject)
  Facility.destroy_all if defined?(Facility)
  FacilityGroup.destroy_all if defined?(FacilityGroup)
  IssueSeverity.destroy_all if defined?(IssueSeverity)
  IssueType.destroy_all if defined?(IssueType)
  IssueStage.destroy_all if defined?(IssueStage)
  TaskStage.destroy_all if defined?(TaskStage)
  TaskType.destroy_all if defined?(TaskType)
  Status.destroy_all if defined?(Status)
  ProjectUser.destroy_all if defined?(ProjectUser)
  Project.destroy_all if defined?(Project)
  ProjectType.destroy_all if defined?(ProjectType)
  Organization.destroy_all if defined?(Organization)
  Setting.destroy_all if defined?(Setting)
  Privilege.destroy_all if defined?(Privilege)
  User.destroy_all if defined?(User)
end

Rails.logger.info "APPCLEANED" # used by log_fail.rb
