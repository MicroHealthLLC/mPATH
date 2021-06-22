class AddReportableToTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :reportable, :boolean, default: false
    add_column :risks, :reportable, :boolean, default: false
    add_column :issues, :reportable, :boolean, default: false
    add_column :lessons, :reportable, :boolean, default: false
  end
end
