desc "Populating database"
task :populate_database => :environment do

  if !Rails.env.development?
    puts "This command is for Development environment."
    Kernel.exit(0)
  end
  
  print "Do you want to remove data from database? y/n :"
  
  remove_data = STDIN.gets.chomp

  if remove_data == "y"
    puts "***** Clearing Database *****"

    Issue.destroy_all
    Task.destroy_all
    FacilityProject.destroy_all
    Facility.destroy_all
    FacilityGroup.destroy_all

    # sequence is required because of foreign key constrain
    ProjectTaskType.destroy_all
    ProjectIssueSeverity.destroy_all
    ProjectIssueType.destroy_all
    ProjectUser.destroy_all
    Project.destroy_all
    ProjectType.destroy_all

    IssueType.destroy_all
    IssueStage.destroy_all
    TaskStage.destroy_all
    IssueSeverity.destroy_all
    TaskType.destroy_all
    Status.destroy_all
    Organization.destroy_all
    Setting.destroy_all
    Privilege.destroy_all
    User.destroy_all
  end


  print "\nHow many facility groups do you want to create? "
  facility_group_number = STDIN.gets.chomp.to_i

  print "\nHow many facilities do you want to create in each facility group? "
  facility_number = STDIN.gets.chomp.to_i

  print "\nHow many projects do you want to create in each project type? "
  project_number = STDIN.gets.chomp.to_i

  print "\nHow many tasks do you want to create in each project? "
  task_number = STDIN.gets.chomp.to_i

  print "\nHow many issues do you want to create in each project? "
  issue_number = STDIN.gets.chomp.to_i


  puts "***** Generating User *****"
  user_count = User.count + 1
  user_email = "user#{user_count}@example.com"
  user = User.find_or_initialize_by(email: user_email)
  user.assign_attributes(
    password: 'changeme',
    password_confirmation: 'changeme',
    title: 'Mr.',
    first_name: "#{user_count}FN",
    role: "superadmin",
    last_name: 'LN'
  )
  user.privilege = Privilege.new(overview: "RWD", tasks: "RWD", notes: "RWD", issues: "RWD", admin: "RWD", map_view: "RWD", gantt_view: "RWD", watch_view: "RWD", documents: "RWD", members: "RWD")
  user.save(validate: false)

  puts "=> email: #{user_email}\n=> password: changeme"

  puts "***** Generating Project Types *****"
  project_type_count = ProjectType.count + 1
  project_types = []
  10.times do |i|
    project_types << ProjectType.new(name: "Project Type#{project_type_count}")
    project_type_count = project_type_count + 1
  end
  ProjectType.import(project_types)

  puts "***** Generating Task Types *****"
  task_type_count = TaskType.count + 1
  task_types = []
  10.times do |i|
    task_types << TaskType.new(name: "Task Type#{task_type_count}")
    task_type_count = task_type_count + 1
  end
  TaskType.import(task_types)

  puts "***** Generating Issue Types *****"
  issue_type_count = IssueType.count + 1
  issue_types = []
  10.times do |i|
    issue_types << IssueType.new(name: "Issue Type#{issue_type_count}")
    issue_type_count = issue_type_count + 1
  end
  IssueType.import(issue_types)


  puts "***** Generating Facility Group *****"
  facility_group_count = FacilityGroup.count + 1
  facility_groups = []
  facility_group_number.times do |i|
    facility_groups << FacilityGroup.new(name: "Facility Group #{facility_group_count}", code: 'SAMP', status: 'active')
    facility_group_count = facility_group_count + 1
  end
  FacilityGroup.import(facility_groups)


  puts "***** Generating Facility *****"
  FacilityGroup.all.each do |fg|
    facilities = []
    facility_count = Facility.count + 1

    facility_number.times do |i|
      facilities << Facility.new(facility_name: "Facility#{facility_count}", facility_group_id: fg.id, creator_id: user.id, address: "Address 1", point_of_contact: "point for contact", phone_number: "123456789", email: "facility#{facility_count}@example.com")
      facility_count = facility_count + 1
    end
    Facility.import(facilities)

  end
  
  puts "***** Generating Task Stage *****"
  task_stage_count = TaskStage.count + 1
  task_stages = []
  10.times do |i|
    task_stages << TaskStage.new(name: "Task Stage #{task_stage_count}")
    task_stage_count = task_stage_count + 1
  end
  TaskStage.import(task_stages)

  puts "***** Generating Issue Stage *****"
  issue_stage_count = IssueStage.count + 1
  issue_stages = []
  10.times do |i|
    issue_stages << IssueStage.new(name: "Issue Stage #{issue_stage_count}")
    issue_stage_count = issue_stage_count + 1
  end
  IssueStage.import(issue_stages)

  puts "***** Generating Issue Severity *****"
  issue_severity_count = IssueSeverity.count + 1
  is = []
  10.times do |i|
    is << IssueSeverity.new(name: "Issue Severity #{issue_severity_count}")
    issue_severity_count = issue_severity_count + 1
  end
  IssueSeverity.import(is)

  puts "***** Generating Projects *****"
  ProjectType.all.each do |pt|
    project_count = Project.count + 1
    projects = []

    project_number.times do |i|
      projects << Project.new({
       "name"=>"project#{project_count}",
       "description"=>nil,
       "project_type_id"=>pt.id,
       "status"=>"active"})

      project_count = project_count + i
    end
    Project.import(projects)
  end
  

  puts "***** Generating Project Users *****"
  project_users = []
  Project.all.each do |p|
    project_users << ProjectUser.new(project_id: p.id, user_id: user.id)
  end
  ProjectUser.import(project_users)

  puts "***** Generating Facility Projects *****"
  facilities = Facility.all
  projects = Project.all
  fps = []
  facilities.each do |f|
    fps << FacilityProject.new(facility_id: f.id, project_id: projects.sample.id)
  end
  FacilityProject.import(fps)

  puts "***** Generating Tasks *****"
  task_types = TaskType.all
  facility_projects = FacilityProject.all
  task_stages = TaskStage.all

  facility_projects.each do |fp|
    task_count = Task.count
    tasks = []

    task_number.times do |i|
      tasks << Task.new({
        text: "task text #{task_count}", description: "task description #{task_count}", 
        due_date: Date.today, task_type_id: task_types.sample.id, start_date: Date.today, 
        facility_project_id: fp.id, task_stage_id: task_stages.sample.id
      })

      task_count = task_count + 1
    end
    Task.import(tasks)
  end


  puts "***** Generating Issues *****"
  issue_types = IssueType.all
  facility_projects = FacilityProject.all
  issue_stages = IssueStage.all
  isssue_severities = IssueSeverity.all

  facility_projects.each do |fp|
    issue_count = Issue.count
    issues = []

    issue_number.times do |i|
      issues << Issue.new({
        title: "Issue #{issue_count}", description: "issue description #{issue_count}", 
        issue_type_id: issue_types.sample.id, issue_severity_id: isssue_severities.sample.id, 
        facility_project_id: fp.id, start_date: Date.today, due_date: Date.today, 
        progress: i, auto_calculate: true, issue_stage_id: issue_stages.sample.id 
      })

      issue_count = issue_count + 1
    end
    Issue.import(issues)
  end

end