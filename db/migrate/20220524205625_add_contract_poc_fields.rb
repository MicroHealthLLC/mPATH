class AddContractPocFields < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_project_data,:co_contract_poc_id, :integer
    add_column :contract_project_data,:gov_contract_poc_id, :integer
    add_column :contract_project_data,:pm_contract_poc_id, :integer
  end
end
