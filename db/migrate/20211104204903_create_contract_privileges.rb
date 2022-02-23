class CreateContractPrivileges < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_privileges do |t|
      t.string :overview, default: [].to_yaml
      t.string :tasks, default: [].to_yaml
      t.string :notes, default: [].to_yaml
      t.string :issues, default: [].to_yaml
      t.string :admin, default: [].to_yaml
      t.string :risks, default: [].to_yaml
      t.integer :user_id
      t.integer :project_id
      t.string :contract_ids, default: [].to_yaml
      t.string :lessons, default: [].to_yaml

      t.timestamps
    end
  end
end
