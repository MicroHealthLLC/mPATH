class ChangeColumncontractProjectData < ActiveRecord::Migration[6.1]
  def change
    change_column :contract_project_data, :billings_to_date, :integer 
  end
end
