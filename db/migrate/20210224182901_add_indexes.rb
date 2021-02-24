class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :project_task_stages, :project_id
    add_index :project_task_stages, :task_stage_id

    add_index :project_risk_stages, :project_id
    add_index :project_risk_stages, :risk_stage_id

    add_index :project_issue_stages, :project_id
    add_index :project_issue_stages, :issue_stage_id

    add_index :progress_lists, :user_id
    add_index :progress_lists, :checklist_id

    add_index :facilities, :status
    
    add_index :checklists, :listable_type
    add_index :checklists, :listable_id

    add_index :issues, :task_type_id    
 
    add_index :notes, :noteable_type
    add_index :notes, :noteable_id

    add_index :related_issues, :relatable_type
    add_index :related_issues, :relatable_id

    add_index :related_risks, :relatable_type
    add_index :related_risks, :relatable_id

    add_index :related_tasks, :relatable_type
    add_index :related_tasks, :relatable_id

    add_index :sorts, :relation
    add_index :sorts, :column
    add_index :sorts, :order

    add_index :task_users, :user_type
    add_index :risk_users, :user_type
    add_index :issue_users, :user_type
  
  end

end
