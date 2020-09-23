class AddOnWatchToIssuesAndTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :watched, :boolean, default: false
    add_column :issues, :watched_at, :datetime
    add_column :tasks, :watched, :boolean, default: false
    add_column :tasks, :watched_at, :datetime
  end
end
