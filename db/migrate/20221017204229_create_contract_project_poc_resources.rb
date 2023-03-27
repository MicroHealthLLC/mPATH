class CreateContractProjectPocResources < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_project_poc_resources do |t|
      t.string :resource_type, null: false
      t.integer :resource_id, null: false
      t.integer :contract_project_poc_id, null: false

      t.timestamps
    end
  end
end
