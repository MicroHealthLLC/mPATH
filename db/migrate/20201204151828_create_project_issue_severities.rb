class CreateProjectIssueSeverities < ActiveRecord::Migration[5.2]
  def change
    create_table :project_issue_severities do |t|
      t.references :issue_severity, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end

    begin
      Project.find_each do |project|
        IssueSeverity.find_each do |issue_severity|
          ProjectIssueSeverity.create(project_id: project.id, issue_severity_id: issue_severity.id)
        end
      end
    rescue
    end
  end
end
