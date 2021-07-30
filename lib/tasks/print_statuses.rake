desc "Print statuses of Tasks, Issues & Risks"
task :print_statuses => :environment do
  f = File.new('statuses.csv', 'w')
  f << "#{"*"*89} TASKS #{"*"*89}\n"
  Task.in_batches(of: 1000).each do |tasks|
    tasks.find_each do |task|
      is_overdue = false
      is_overdue = task.progress < 100 && (task.due_date < Date.today) if !task.ongoing && !task.on_hold && !task.draft
      planned = false
      planned = true if !task.draft && task.start_date > Date.today
      in_progress = false
      in_progress = true if !task.draft && !task.on_hold && !is_overdue && !task.ongoing && task.progress >= 100 && task.start_date < Date.today

      f << "Task ID: #{task.id}, Draft: #{task.draft}, OnHold: #{task.on_hold}, OnGoing: #{task.ongoing}, Overdue: #{is_overdue}, Planned: #{planned}, InProgress: #{in_progress}\n"
    end
  end

  f << "#{"*"*89} RISKS #{"*"*89}\n"
  Risk.in_batches(of: 1000).each do |risks|
    risks.find_each do |risk|
      is_overdue = false
      is_overdue = risk.progress < 100 && (risk.due_date < Date.today) if !risk.ongoing && !risk.on_hold && !risk.draft

      f << "Risk ID: #{risk.id}, Draft: #{risk.draft}, OnHold: #{risk.on_hold}, OnGoing: #{risk.ongoing}, Overdue: #{is_overdue}\n"
    end
  end

  f << "#{"*"*89} ISSUES #{"*"*89}\n"
  Issue.in_batches(of: 1000).each do |issues|
    issues.find_each do |issue|
      is_overdue = false
      is_overdue = issue.progress < 100 && (issue.due_date < Date.today) if !issue.on_hold && !issue.draft

      f << "Issue ID: #{issue.id}, Draft: #{issue.draft}, OnHold: #{issue.on_hold}, Overdue: #{is_overdue}\n"
    end
  end
  f.close
end