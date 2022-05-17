class CreateProjectContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :project_contracts do |t|
      t.integer :project_id, null: false
      t.integer :contract_id, null: false

      t.timestamps
    end
  end
end
