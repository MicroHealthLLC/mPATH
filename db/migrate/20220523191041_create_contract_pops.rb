class CreateContractPops < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_pops do |t|
      t.string :name

      t.timestamps
    end
    rename_column :contract_project_data, :contract_pops, :contract_pop_id
  end
end
