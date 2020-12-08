class CreateProjectTaskTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :project_task_types do |t|
      t.references :task_type, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end

    begin
      Project.find_each do |project|
        TaskType.find_each do |task_type|
          ProjectTaskType.create(project_id: project.id, task_type_id: task_type.id)
        end
      end
    rescue
    end
  end
end
