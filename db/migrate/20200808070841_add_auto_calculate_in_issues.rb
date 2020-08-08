class AddAutoCalculateInIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :auto_calculate, :boolean, default: true
    begin
      Issue.update_all auto_calculate: false
    rescue
      nil
    end
  end
end
