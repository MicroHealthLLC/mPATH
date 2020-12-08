class CreateProjectStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :project_statuses do |t|
      t.references :status, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end

    begin
      Project.find_each do |project|
        Status.find_each do |status|
          ProjectStatus.create(project_id: project.id, status_id: status.id)
        end
      end
    rescue
    end
  end
end
