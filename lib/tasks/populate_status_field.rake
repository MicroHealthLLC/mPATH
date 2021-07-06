desc "Populate status field in Task, Issue & Risk"
task :populate_status_in_tasks => :environment do
  Task.all.each do |task|
    if task.draft
      task.draft!
    elsif task.progress < 100 && task.due_date < Date.today
      task.overdue!
    elsif task.ongoing
      task.ongoing!
    elsif task.on_hold
      task.on_hold!
    elsif !task.draft && task.start_date > Date.today
      task.planned!
    elsif !task.draft && !task.on_hold && !task.ongoing && task.start_date < Date.today
      task.in_progress!
    elsif !task.draft && !task.on_hold && !task.ongoing && task.progress >= 100
      task.completed!
    end
  end
end

task :populate_status_in_risks => :environment do
  Risk.all.each do |risk|
    if risk.draft
      risk.draft!
    elsif !risk.draft && !risk.on_hold && !risk.ongoing && risk.progress < 100 && risk.due_date < Date.today
      risk.overdue!
    elsif risk.ongoing
      risk.ongoing!
    elsif risk.on_hold
      risk.on_hold!
    elsif !risk.draft && risk.start_date > Date.today
      risk.planned!
    elsif !risk.draft && !risk.on_hold && !risk.ongoing && risk.start_date < Date.today
      risk.in_progress!
    elsif !risk.draft && !risk.on_hold && !risk.ongoing && risk.progress >= 100
      risk.completed!
    end
  end
end

task :populate_status_in_issues => :environment do
  Issue.all.each do |issue|
    if issue.draft
      issue.draft!
    elsif !issue.draft && !issue.on_hold && issue.progress < 100 && issue.due_date < Date.today
      issue.overdue!
    elsif issue.on_hold
      issue.on_hold!
    elsif !issue.draft && issue.start_date > Date.today
      issue.planned!
    elsif !issue.draft && !issue.on_hold && issue.start_date < Date.today
      issue.in_progress!
    elsif !issue.draft && !issue.on_hold && issue.progress >= 100
      issue.completed!
    end
  end
end