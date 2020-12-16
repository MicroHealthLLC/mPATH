class CreateProjectIssueTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :project_issue_types do |t|
      t.references :issue_type, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end

    begin
      Project.find_each do |project|
        IssueType.find_each do |issue_type|
          ProjectIssueType.create(project_id: project.id, issue_type_id: issue_type.id)
        end
      end
    rescue
    end
  end
end
