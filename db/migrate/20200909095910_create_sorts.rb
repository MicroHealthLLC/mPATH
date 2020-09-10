class CreateSorts < ActiveRecord::Migration[5.2]
  def change
    create_table :sorts do |t|
      t.string :relation
      t.string :column, default: 'id'
      t.string :order, default: 'asc'
      t.timestamps
    end

    Sort.create([
      {relation: 'checklists'},
      {relation: 'facilities'},
      {relation: 'facility_groups'},
      {relation: 'facility_projects'},
      {relation: 'issue_severities'},
      {relation: 'issue_types'},
      {relation: 'issue_users'},
      {relation: 'issues'},
      {relation: 'notes'},
      {relation: 'privileges'},
      {relation: 'project_types'},
      {relation: 'project_users'},
      {relation: 'projects'},
      {relation: 'region_states'},
      {relation: 'statuses'},
      {relation: 'task_types'},
      {relation: 'tasks'},
      {relation: 'users'}
    ])
  end
end
